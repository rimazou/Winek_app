import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'dart:core';
import 'classes.dart';
import 'auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Databasegrp {
  String pseudo;
  String id;

  Databasegrp({this.pseudo, this.id});
/*
  static void getcurret(String id, String pseudo) async {
    id = await authService.connectedID();
    print('id: $id');
    /* await authService.connectedID().then((String uid) {
      id = uid;
      print('id: $id');
    });*/

    pseudo = await Firestore.instance
        .collection('Utilisateur')
        .document(id)
        .get()
        .then((DocumentSnapshot doc) {
      return doc.data['pseudo'];
    });
    print('pseudo: $pseudo');
  }
*/
  final CollectionReference friendsCollection =
      Firestore.instance.collection('Friends');

  // final CollectionReference friendRequestCollection = Firestore.instance.collection('Invitations');
  final CollectionReference usersCollection =
      Firestore.instance.collection('Utilisateurs');
  final CollectionReference voyageCollection =
      Firestore.instance.collection('Voyage');
  final CollectionReference longtermeCollection =
      Firestore.instance.collection('LongTerme');

  Future<bool> updatelistinvitations(String id, String grpid, String grpname) {
    DocumentReference invitationsReference =
        Firestore.instance.collection('UserGrp').document(id);
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

  Future<bool> updatelistgroupes(String id, String grpid, String grpname) {
    DocumentReference groupesReference =
        Firestore.instance.collection('UserGrp').document(id);
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

  Future<bool> updategroupemembers(String ref, String mpseudo, String mid) {
    Map membre = {'pseudo': mpseudo, 'id': mid};
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
    Map grp = {'chemin': ref, 'nom': nom};
    //update groupes liste
    try {
      await Firestore.instance
          .collection('UserGrp')
          .where('groupes', arrayContains: [grp])
          .snapshots()
          .listen((data) => data.documents.forEach((doc) async {
                print(doc.data['pseudo']);
                await updatelistgroupes(doc.documentID, ref, nom);
                await updatelistgroupes(doc.documentID, ref, nvnom);
              }));
    } catch (e) {
      print(e.toString());
    }
    try {
      await Firestore.instance
          .collection('UserGrp')
          .where('invitations', arrayContains: [grp])
          .snapshots()
          .listen((data) => data.documents.forEach((doc) async {
                await updatelistinvitations(doc.documentID, ref, nom);
                await updatelistinvitations(doc.documentID, ref, nvnom);
              }));
    } catch (e) {
      print(e.toString());
    }
    try {
      await Firestore.instance.document(ref).updateData({'nom': nvnom});
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
                doc.reference.updateData({
                  'groupes': FieldValue.arrayRemove([grp])
                });
                //updatelistgroupes(doc.documentID, ref, nom);
              }));
    } catch (e) {
      print(e.toString());
    }
    try {
      Firestore.instance
          .collection('UserGrp')
          .where('invitations', arrayContains: [grp])
          .snapshots()
          .listen((data) => data.documents.forEach((doc) {
                doc.reference.updateData({
                  'invitations': FieldValue.arrayRemove([grp])
                });
                // updatelistinvitations(doc.data['pseudo'], ref, nom);
              }));
    } catch (e) {
      print(e.toString());
    }
  }

  void quittergroupe(String ref, String nom) async {
    this.id = await authService.connectedID();
    pseudo = await Firestore.instance
        .collection('Utilisateur')
        .document(id)
        .get()
        .then((Doc) {
      return Doc.data['pseudo'];
    });
    Map grp = {'chemin': ref, 'nom': nom};
    //update groupes liste
    try {
      Firestore.instance.collection('UserGrp').document(id).updateData({
        'groupes': FieldValue.arrayRemove([grp]),
      });
    } catch (e) {
      print(e.toString());
    }
    try {
      updategroupemembers(ref, pseudo, id);
    } catch (e) {
      print(e.toString());
    }
  }

  void invitemember(String ref, String nom, String memberid) async {
    updatelistinvitations(memberid, ref, nom);
  }

  void deletemember(
      String ref, String nom, String memberid, String memberpseudo) async {
    await updatelistgroupes(memberid, ref, nom);
    await updategroupemembers(ref, memberpseudo, memberid);
    //delete lemis doc
  }

  void refuseinvitation(String ref, String nom) async {
    this.id = await authService.connectedID();
    pseudo = await Firestore.instance
        .collection('Utilisateur')
        .document(id)
        .get()
        .then((Doc) {
      return Doc.data['pseudo'];
    });
    Map grp = {'chemin': ref, 'nom': nom};
    // await updatelistinvitations(pseudo, ref, nom);
    try {
      Firestore.instance.collection('UserGrp').document(id).updateData({
        'invitations': FieldValue.arrayRemove([grp]),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void acceptinvitation(String ref, String nom) async {
    id = await authService.connectedID();
    pseudo = await Firestore.instance
        .collection('Utilisateur')
        .document(id)
        .get()
        .then((Doc) {
      return Doc.data['pseudo'];
    });
    print(id);
    Map grp = {'chemin': ref, 'nom': nom};
    print(grp);
    // await updatelistinvitations(pseudo, ref, nom);
    // await updatelistgroupes(pseudo, ref, nom);
    await Firestore.instance
        .collection('UserGrp')
        .document(id)
        .get()
        .then((DocumentSnapshot doc) {
      doc.reference.updateData({
        'invitations': FieldValue.arrayRemove([grp]),
        'groupes': FieldValue.arrayUnion([grp]),
        'pseudo': pseudo
      });
    });
    await updategroupemembers(ref, pseudo, id);

    Geoflutterfire geo = Geoflutterfire();
    GeoFirePoint point = geo.point(latitude: 0.0, longitude: 0.0);
    await Firestore.instance
        .document(ref)
        .collection('members')
        .document(id)
        .setData({
      'position': point.data,
    });
  }

  Future<List<Map<dynamic, dynamic>>> getListInvitations() async {
    Map user = {'pseudo': '', 'id': ''};
    user['id'] = await authService.connectedID();
    user['pseudo'] = await Firestore.instance
        .collection('Utilisateur')
        .document(user['id'])
        .get()
        .then((Doc) {
      return Doc.data['pseudo'];
    });
    print("user : $user");
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('UserGrp')
        .document(user['id'])
        .get();
    print(querySnapshot.data.toString());
    if (querySnapshot.exists && querySnapshot.data.containsKey('invitations')) {
      return List<Map<dynamic, dynamic>>.from(
          querySnapshot.data['invitations']);
    }
    return [];
  }
}
