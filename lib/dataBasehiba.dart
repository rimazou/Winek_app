import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'package:flutter/cupertino.dart';
import 'dart:core';
import 'classes.dart';
import 'auth.dart';

class Database {
  final String pseudo;
  final String id;

  var current = authService
      .connectedID(); // il reste berk nchouf kifach yemchi bien le truc ta3 future des fois ca rend pas direct un string et tt

  Database({@required this.pseudo, @required this.id});

 static void getcurret(String id , String pseudo)async{
   await authService.connectedID().then((String uid){
     id = uid;
   });
  await Firestore.instance.document(id).get().then((DocumentSnapshot doc){
    pseudo = doc.data['pseudo'];
  });
 }


  final CollectionReference friendsCollection =
      Firestore.instance.collection('Friends');

  // final CollectionReference friendRequestCollection = Firestore.instance.collection('Invitations');
  final CollectionReference usersCollection =
      Firestore.instance.collection('Utilisateurs');
  final CollectionReference voyageCollection =
      Firestore.instance.collection('Voyage');
  final CollectionReference longtermeCollection =
      Firestore.instance.collection('LongTerme');

  List<Utilisateur> _friendListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Utilisateur(pseudo: doc.data['pseudo'] ?? '');
    }).toList();
  }

  List<Utilisateur> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Utilisateur(pseudo: doc.data['pseudo'] ?? '');
    }).toList();
  }

  Stream<List<Utilisateur>> get users {
    return usersCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<List<Utilisateur>> get friends {
    return friendsCollection.snapshots().map(_friendListFromSnapshot);
  }

  Future<List<Groupe>> groupeslist() async {
    DocumentSnapshot querySnapshot =
        await Firestore.instance.collection('UserGrp').document(pseudo).get();
    // print(querySnapshot.data['pseudo']);
    if (querySnapshot.exists &&
        querySnapshot.data.containsKey('groupes') &&
        querySnapshot.data['groupes'] is List) {
      // Create a new List<String> of ref
      List<String> grpref = List<String>.from(querySnapshot.data['groupes']);
      List<Groupe> g = List();
      for (String ref in grpref) {
        if (ref.startsWith('LongTerme')) {
          Firestore.instance.document(ref).get().then((DocumentSnapshot doc) {
            LongTerme lt = LongTerme.fromMap(doc.data);
            g.add(lt);
          });
        }
        if (ref.startsWith('Voyage')) {
          Firestore.instance.document(ref).get().then((DocumentSnapshot doc) {
            g.add(Voyage.fromMap(doc.data));
          });
        }
      }
      return g;
    }
  }

/*  List<Invitation> _friendRequestListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){

      return Invitation(
          pseudo : doc.data['pseudo'] ?? ''

      );}).toList();
  }

  Stream<List<Invitation>> get friendRequest {
    return friendRequestCollection.snapshots().map(_friendRequestListFromSnapshot);
  }
*/

  Future<bool> updatelistinvitations(
      String pseudo, String grpid, String grpname) {
    DocumentReference invitationsReference =
        Firestore.instance.collection('UserGrp').document(pseudo);
    Map grp = {'chemin': grpid, 'nom': grpname};
    return Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(invitationsReference);
      if (postSnapshot.exists && postSnapshot.data.containsKey('invitations')) {
        // that user exist and has at least one grp
        if (!postSnapshot.data['invitations'].contains(grp)) {
          await tx.update(invitationsReference, <String, dynamic>{
            'invitations': FieldValue.arrayUnion([grp])
          });
          // if its already there, we're gonna delete it:
        } else {
          await tx.update(invitationsReference, <String, dynamic>{
            'invitations': FieldValue.arrayRemove([grp])
          });
        }
      } else {
        // Create a document for the current user in collection 'UserGrp'
        // and add a new array 'invitations' to the document
        if (postSnapshot.exists) {
          await tx.update(invitationsReference, <String, dynamic>{
            'invitations': [grp]
          });
        } else {
          await tx.set(invitationsReference, {
            'invitations': [grp],
            'pseudo': pseudo,
          });
        }
      }
    }).then((result) {
      print('invitations added succefully');
      return true;
    }).catchError((error) {
      print('Error: $error');
      return false;
    });
  }

  Future<bool> updatelistgroupes(String pseudo, String grpid, String grpname) {
    DocumentReference groupesReference =
        Firestore.instance.collection('UserGrp').document(pseudo);
    Map grp = {'chemin': grpid, 'nom': grpname};
    return Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(groupesReference);
      if (postSnapshot.exists && postSnapshot.data.containsKey('invitations')) {
        // that user exist and has at least one grp
        if (!postSnapshot.data['groupes'].contains(grp)) {
          await tx.set(groupesReference, <String, dynamic>{
            'groupes': FieldValue.arrayUnion([grp])
          });
          // if its already there, we're gonna delete it:
        } else {
          await tx.set(groupesReference, <String, dynamic>{
            'groupes': FieldValue.arrayRemove([grp])
          });
        }
      } else {
        // Create a document for the current user in collection 'UserGrp'
        // and add a new array 'groupes' to the document:
        if (postSnapshot.exists) {
          await tx.set(groupesReference, <String, dynamic>{
            'groupes': [grp]
          });
        } else {
          await tx.set(groupesReference, {
            'groupes': [grp],
            'pseudo': pseudo,
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

  Future<bool> updategroupemembers(String ref, String membre) {
    DocumentReference groupesReference = Firestore.instance.document(ref);
    return Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(groupesReference);
      if (postSnapshot.exists) {
        // that grp exist
        if (!postSnapshot.data['membres'].contains(membre)) {
          await tx.update(groupesReference, <String, dynamic>{
            'membres': FieldValue.arrayUnion([membre])
          });
          // if its already there, we're gonna delete it:
        } else {
          await tx.update(groupesReference, <String, dynamic>{
            'membres': FieldValue.arrayRemove([membre])
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

  Future<bool> updategroupename(String ref, String nom, String nvnom) async {
    try {
      await Firestore.instance.document(ref).updateData({'nom': nvnom});
    } catch (e) {
      print(e.toString());
    }
    Map grp = {'chemin': ref, 'nom': nom};
    //update groupes liste
    try {
      Firestore.instance
          .collection('UserGrp')
          .where('groupes', arrayContains: grp)
          .snapshots()
          .listen((data) => data.documents.forEach((doc) {
                print(doc.data['pseudo']);
                updatelistgroupes(doc.data['pseudo'], ref, nom);
                updatelistgroupes(doc.data['pseudo'], ref, nvnom);
              }));
    } catch (e) {
      print(e.toString());
    }
    try {
      Firestore.instance
          .collection('UserGrp')
          .where('invitations', arrayContains: grp)
          .snapshots()
          .listen((data) => data.documents.forEach((doc) {
                updatelistinvitations(doc.data['pseudo'], ref, nom);
                updatelistinvitations(doc.data['pseudo'], ref, nvnom);
              }));
    } catch (e) {
      print(e.toString());
    }
  }

  void fermergroupe(String ref, String nom) async {
    try {
      await Firestore.instance.document(ref).delete();
    } catch (e) {
      print(e.toString());
    }
    Map grp = {'chemin': ref, 'nom': nom};
    //update groupes liste
    try {
      Firestore.instance
          .collection('UserGrp')
          .where('groupes', arrayContains: [grp])
          .snapshots()
          .listen((data) => data.documents.forEach((doc) {
                print(doc.data['pseudo']);
                //updatelistgroupes(doc.data['pseudo'], ref, nom);
              }));
    } catch (e) {
      print(e.toString());
    }
    try {
      Firestore.instance
          .collection('UserGrp')
          .where('invitations', arrayContains: grp)
          .snapshots()
          .listen((data) => data.documents.forEach((doc) {
                updatelistinvitations(doc.data['pseudo'], ref, nom);
              }));
    } catch (e) {
      print(e.toString());
    }
  }

  void quittergroupe(String ref, String nom) async {
    Map grp = {'chemin': ref, 'nom': nom};
    //update groupes liste
    try {
      Firestore.instance.collection('UserGrp').document(pseudo).updateData({
        'groupes': FieldValue.arrayRemove([grp]),
      });
    } catch (e) {
      print(e.toString());
    }
    try {
      updategroupemembers(ref, pseudo);
    } catch (e) {
      print(e.toString());
    }
  }

  void addmember(String ref, String nom, String member) async {
    await updategroupemembers(ref, member);
    await updatelistinvitations(member, ref, nom);
  }

  void deletemember(String ref, String nom, String member) async {
    await updatelistgroupes(member, ref, nom);
    await updategroupemembers(ref, member);
  }

  void refuseinvitation(String ref, String nom) async {
    Map grp = {'chemin': ref, 'nom': nom};
    // await updatelistinvitations(pseudo, ref, nom);
    try {
      Firestore.instance.collection('UserGrp').document(pseudo).updateData({
        'invitations': FieldValue.arrayRemove([grp]),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void acceptinvitation(String ref, String nom) async {
    Map grp = {'chemin': ref, 'nom': nom};
    // await updatelistinvitations(pseudo, ref, nom);
    // await updatelistgroupes(pseudo, ref, nom);
    await Firestore.instance
        .collection('UserGrp')
        .document(pseudo)
        .get()
        .then((DocumentSnapshot doc) {
      doc.reference.updateData({
        'invitations': FieldValue.arrayRemove([grp]),
        'groupes': FieldValue.arrayUnion([grp]),
        'pseudo': pseudo
      });
    });
    await updategroupemembers(ref, pseudo);
  }


}
