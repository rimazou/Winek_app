import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';

class Database {
  String pseudo;
  String id;
  String subiid;
  String subipseudo;

  List<dynamic> _modifiedUsersInterested;
  String currentUser;

  String currentName;
  final CollectionReference userCollection =
      Firestore.instance.collection('Utilisateur');

  Database(
      {String pseudo,
      String subiid,
      String subipseudo,
      String id,
      List<dynamic> modifiedUsersInterested,
      String current}) {
    this.pseudo = pseudo;
    this.subipseudo = subipseudo;
    this.subiid = subiid;
    this.id = id;
    this.currentUser = current;
    _modifiedUsersInterested =
        modifiedUsersInterested != null ? modifiedUsersInterested : [];
  }

  Future init(
      {String pseudo,
      String id,
      String subiid,
      String subipseudo,
      String currentid}) async {
    String currentUser = currentid;

    await getPseudo(currentUser).then((docSnap) {
      currentName = docSnap;
    });

    this.pseudo = pseudo != null ? pseudo : currentName;

    this.subipseudo = subipseudo != null ? subipseudo : currentName;
    this.subiid = this.subipseudo == currentName
        ? currentUser
        : await getID(this.subipseudo);

    this.id = id != null ? id : await getID(pseudo);

    await userCollection.getDocuments().then((QuerySnapshot data) {
      for (var doc in data.documents) {
        // data.documents.forEach((doc) {
        if (doc.data['pseudo'] == this.subipseudo)
          this._modifiedUsersInterested = doc.data['amis'];
      }
    });

    var d = Database(
        pseudo: this.pseudo,
        subipseudo: this.subipseudo,
        id: this.id,
        subiid: this.subiid,
        modifiedUsersInterested: this._modifiedUsersInterested,
        current: currentUser);
    return d;
  }

  Future userUpdateData({String name}) async {
    // ajouter un amis a la liste de current
    Map map;

    map = ({'pseudo': this.pseudo, 'id': this.id});

    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('Utilisateur')
        .document(subiid)
        .get();
    if (querySnapshot.exists && querySnapshot.data.containsKey('amis')) {
      if (querySnapshot.data['amis'] == null) {
        querySnapshot.reference.updateData({
          'amis': [map],
        });
      } else {
        querySnapshot.reference.updateData({
          'amis': FieldValue.arrayUnion([map]),
        });
      }
    }
/*
    if (_modifiedUsersInterested.isNotEmpty) {
      _modifiedUsersInterested.add(map);
    }

    else {
    _modifiedUsersInterested= [];
    _modifiedUsersInterested.add(map);
    }

    return await userCollection
        .document(subiid)
        .updateData(
        {'amis': _modifiedUsersInterested});
   */
  }

  Future userDeleteData(String current) async {
    // supprimer une invit de pseudo de la liste de current
    return await userCollection.document(current).updateData({
      "invitation ": FieldValue.arrayRemove([pseudo])
    });
  }

  Future invitUpdateData(String current) async {
    // ajouter une invit de pseudo a la liste de current
    return await userCollection.document(current).updateData({
      "invitation ": FieldValue.arrayUnion([pseudo])
    });
  }

  Future friendDeleteData(String id) async {
    // supprimer un ami id de la liste de current, (id dans le constructeur)

    if (_modifiedUsersInterested != null) {
      for (var map in _modifiedUsersInterested) {
        if (map["pseudo"] == this.pseudo) {
          _modifiedUsersInterested.remove(map);
        }
      }
    }

    if (_modifiedUsersInterested != null) {
      return await userCollection
          .document(id)
          .updateData({'amis': _modifiedUsersInterested});
    } else {
      return await userCollection.document(id).updateData({'amis': []});
    }
    /* return await userCollection.document(pseudo).updateData({
      "amis": FieldValue.arrayRemove([{pseudo: id , id: getID(id)}])
    });*/
  }

  List<String> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      String pseudo = doc.data['pseudo'] ?? '';
      return pseudo;
    }).toList();
  }

  Stream<List<String>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  String get currentuser {
    return currentUser;
  }

  String get currentname {
    return currentName;
  }

  Stream<List<dynamic>> get friends {
    return userCollection.document(currentUser).snapshots().map((snap) {
      List<dynamic> friend = snap.data['amis'];
      return friend;
    });
  }

  Stream<List<String>> get friendRequest {
    return userCollection.document(this.currentUser).snapshots().map((snap) {
      List<String> invit;
      if (snap.data['invitation '] != null) {
        invit = snap.data['invitation '].cast<String>();
      }
      return invit;
    });
  }

  Future<List<Map<dynamic, dynamic>>> getlistfriend() async {
    List<dynamic> friendsid = List();
    await Firestore.instance
        .collection('Utilisateur')
        .document(currentUser)
        .get()
        .then((DocumentSnapshot doc) {
      friendsid = doc.data['amis'];
    });
    List<dynamic> pseudos = List();
    for (String id in friendsid) {
      await Firestore.instance
          .collection('Utilisateur')
          .document(id)
          .get()
          .then((DocumentSnapshot doc) {
        pseudos.add(doc.data['pseudo']);
      });
    }
    List<Map<dynamic, dynamic>> friendlist = List();
    for (int index = 0; index < friendsid.length; index++) {
      friendlist.add({'pseudo': pseudos[index], 'id': friendsid[index]});
    }
    return friendlist;
  }

  Future<List<Map<dynamic, dynamic>>> getUsers() async {
    List<dynamic> userid = List();
    await Firestore.instance
        .collection('Utilisateur')
        .getDocuments()
        .then((QuerySnapshot data) {
      for (var doc in data.documents) {
        // data.documents.forEach((doc) {
        userid.add(doc.documentID);
      }
    });
    List<dynamic> pseudos = List();

    await Firestore.instance
        .collection('Utilisateur')
        .getDocuments()
        .then((QuerySnapshot data) {
      for (var doc in data.documents) {
//      data.documents.forEach((doc) {
        pseudos.add(doc.data['pseudo']);
      }
    });

    List<Map<dynamic, dynamic>> friendlist = List();
    for (int index = 0; index < userid.length; index++) {
      friendlist.add({'pseudo': pseudos[index], 'id': userid[index]});
    }
    return friendlist;
  }

  Future<String> getPseudo(String id) async {
    String name = 'marche pas';
    await Firestore.instance
        .collection('Utilisateur')
        .document(id)
        .get()
        .then((docSnap) {
      if (docSnap.data != null) {
        name = docSnap.data['pseudo'];
      }
    });
    return name;
  }

  Future<String> getPhoto(String pseudo) async {
    String image;
    Firestore.instance
        .collection('Utilisateur')
        .where("pseudo", isEqualTo: pseudo)
        .limit(1)
        .snapshots()
        .listen((data) {
      for (var doc in data.documents) {
        //  data.documents.forEach((doc)
        image = doc.data['photo'];
      }
    });
    return image.toString();
  }

  Future<String> getID(String pseudo) async {
    String id;
    await userCollection.getDocuments().then((QuerySnapshot data) {
      for (var doc in data.documents) {
        // data.documents.forEach((doc) {
        if (doc.data['pseudo'] == pseudo) id = doc.documentID;
      }
    });
    return id.toString();
  }

  Future<bool> updategroupemembers(
      String ref, String mpseudo, String mid) async {
    Map membre = {'pseudo': mpseudo, 'id': mid};
    bool exist = false;
    DocumentReference groupesReference = Firestore.instance.document(ref);
    return Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(groupesReference);
      if (postSnapshot.exists) {
        // that grp exist
        for (var map in postSnapshot.data['membres']) {
          if (map['id'] == mid) {
            exist = true;
            await tx.update(groupesReference, <String, dynamic>{
              'membres': FieldValue.arrayRemove([membre])
            });
            // if its already there, we're gonna delete it:
          }
        }
        if (!exist) {
          await tx.update(groupesReference, <String, dynamic>{
            'membres': FieldValue.arrayUnion([membre])
          });
        }
      }
    }).then((result) {
      return true;
    }).catchError((error) {
      print('Error: $error');
      return false;
    });
  }

  Future<Null> changePseudo(String oldp, String newp) async {
    String id = await getID(oldp);
    Map fellow = {'pseudo': oldp, 'id': id};
    await userCollection.getDocuments().then((QuerySnapshot data) async {
      for (var doc in data.documents) {
        // data.documents.forEach((doc) async {
        if (doc.data['pseudo'] == oldp) {
          await userCollection
              .document(doc.documentID)
              .updateData({'pseudo': newp});
        } else {
          List<dynamic> list = doc.data['amis'];
          if (list != null) {
            for (var map in list) {
              if (map['id'] == id) {
                await Database(pseudo: oldp).friendDeleteData(doc.documentID);
                Database d = await Database()
                    .init(pseudo: newp, id: id, subipseudo: doc.data['pseudo']);
                await d.userUpdateData();
              }
            }
          }
          List<dynamic> listinvit = doc.data['invitation '];
          if (listinvit != null) {
            if (listinvit.contains(oldp)) {
              await Database(pseudo: oldp).userDeleteData(doc.documentID);
              await Database(pseudo: newp).invitUpdateData(doc.documentID);
            }
          }
        }
      }
    });

    await Firestore.instance
        .collection('UserGrp')
        .document(id)
        .get()
        .then((DocumentSnapshot doc) async {
      if (doc.data['pseudo'] == oldp) {
        await Firestore.instance
            .collection('UserGrp')
            .document(id)
            .updateData({'pseudo': newp});
      }

      List<dynamic> groupes = doc.data['groupes'];
      for (var map in groupes) {
        String grp = map["chemin"];

        await Firestore.instance
            .document(grp)
            .get()
            .then((DocumentSnapshot data) async {
          if (data.data['admin'] == oldp) {
            await Firestore.instance.document(grp).updateData({'admin': newp});
          }

          List<dynamic> membres = List.from(data.data['membres']);
          if (membres != null) {
            for (var map in membres) {
              if (map['id'] == id) {
                await updategroupemembers(grp, oldp, id);
                await updategroupemembers(grp, newp, id);
              }
            }
          }

          try {
            await Firestore.instance
                .document(grp)
                .collection('receivedAlerts')
                .getDocuments()
                .then((QuerySnapshot data) async {
              if (data != null)
                for (var doc in data.documents) {
                  //data.documents.forEach((doc)  {
                  if (doc != null) {
                    if (doc.data['sender'] == oldp) {
                      await doc.reference.updateData({'sender': newp});
                    }
                  }
                }
            });
          } catch (e) {
            print(e.toString());
          }
        });
      }
    });
  }
}
