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
*/
  Future<bool> updategroupename(String ref, String nom, String nvnom) async {
    Map grp = {'chemin': ref, 'nom': nom};
    //update groupes liste
    await Firestore.instance
        .collection('UserGrp')
        .getDocuments()
        .then((QuerySnapshot data) {
      data.documents.forEach((doc) async {
        List<dynamic> list = doc.data['groupes'];
        if (list != null) {
          for (Map map in list) {
            if (map['chemin'] == ref) {
              // await updatelistgroupes(doc.documentID, ref, nom);
              await doc.reference.updateData({
                'groupes': FieldValue.arrayRemove([grp]),
              });
              // await updatelistgroupes(doc.documentID, ref, nvnom);
              await doc.reference.updateData({
                'groupes': FieldValue.arrayUnion([
                  {'chemin': ref, 'nom': nvnom}
                ]),
              });
            }
          }
        }
      });
    });
    print('updated groupes');
    await Firestore.instance
        .collection('UserGrp')
        .getDocuments()
        .then((QuerySnapshot data) {
      data.documents.forEach((doc) async {
        List<dynamic> list = doc.data['invitations'];
        if (list != null) {
          for (Map map in list) {
            if (map['chemin'] == ref) {
              // await updatelistgroupes(doc.documentID, ref, nom);
              await doc.reference.updateData({
                'invitations': FieldValue.arrayRemove([grp]),
              });
              // await updatelistgroupes(doc.documentID, ref, nvnom);
              await doc.reference.updateData({
                'invitations': FieldValue.arrayUnion([
                  {'chemin': ref, 'nom': nvnom}
                ]),
              });
            }
          }
        }
      });
    });
    print('updated invitations');

    try {
      await Firestore.instance.document(ref).updateData({'nom': nvnom});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fermergroupe(String ref, String nom) async {
    Map grp = {'chemin': ref, 'nom': nom};
    await Firestore.instance
        .collection('UserGrp')
        .getDocuments()
        .then((QuerySnapshot data) {
      data.documents.forEach((doc) async {
        List<dynamic> list = doc.data['groupes'];
        if (list != null) {
          for (Map map in list) {
            if (map['chemin'] == ref) {
              // await updatelistgroupes(doc.documentID, ref, nom);
              await doc.reference.updateData({
                'groupes': FieldValue.arrayRemove([grp]),
              });
            }
          }
        }
      });
    });
    print('updated groupes');
    await Firestore.instance
        .collection('UserGrp')
        .getDocuments()
        .then((QuerySnapshot data) {
      data.documents.forEach((doc) async {
        List<dynamic> list = doc.data['invitations'];
        if (list != null) {
          for (Map map in list) {
            if (map['chemin'] == ref) {
              // await updatelistgroupes(doc.documentID, ref, nom);
              await doc.reference.updateData({
                'invitations': FieldValue.arrayRemove([grp]),
              });
            }
          }
        }
      });
    });
    print('updated invitations');
    // dont forget to delete the docs in the subcollections
    await Firestore.instance.document(ref).delete();
    print("groupe deleted");
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
      //  await updategroupemembers(ref, pseudo, id);
      await Firestore.instance.document(ref).updateData({
        'membres': FieldValue.arrayRemove([
          {'id': id, 'pseudo': pseudo}
        ]),
      });
      await Firestore.instance
          .document(ref)
          .collection('members')
          .document(id)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  void invitemember(String ref, String nom, String memberid) async {
    //await updatelistinvitations(memberid, ref, nom);
    await Firestore.instance
        .collection("UserGrp")
        .document(memberid)
        .updateData({
      'invitations': FieldValue.arrayUnion([
        {'chemin': ref, 'nom': nom}
      ])
    });
  }

  void deletemember(
      String ref, String nom, String memberid, String memberpseudo) async {
    //  await updatelistgroupes(memberid, ref, nom);
    await Firestore.instance
        .collection('UserGrp')
        .document(memberid)
        .updateData({
      'groupes': FieldValue.arrayRemove([
        {'chemin': ref, 'nom': nom}
      ]),
    });
    // await updategroupemembers(ref, memberpseudo, memberid);
    await Firestore.instance.document(ref).updateData({
      'membres': FieldValue.arrayRemove([
        {'id': memberid, 'pseudo': memberpseudo}
      ]),
    });
    //delete lemis doc
    await Firestore.instance
        .document(ref)
        .collection('members')
        .document(memberid)
        .delete();
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
    // await updategroupemembers(ref, pseudo, id);
    await Firestore.instance.document(ref).updateData({
      'membres': FieldValue.arrayUnion([
        {'id': id, 'pseudo': pseudo}
      ])
    });

    Geoflutterfire geo = Geoflutterfire();
    GeoFirePoint point = geo.point(latitude: 0.0, longitude: 0.0);
    await Firestore.instance
        .document(ref)
        .collection('members')
        .document(id)
        .setData({
      'position': point.data,
    });
    GeoPoint position;
    GeoFirePoint geoFirePoint;
//  Geoflutterfire geo = Geoflutterfire();
    Firestore.instance
        .collection('Utilisateur')
        .document(id)
        .snapshots(includeMetadataChanges: true)
        .listen((DocumentSnapshot documentSnapshot) {
      position = documentSnapshot.data['location']['geopoint'];
      /*await _firestore.collection('Utilisateur').document(userID).get().then((DocumentSnapshot ds) {
      position = ds.data['location']['geopoint'];
    });*/
      geoFirePoint =
          geo.point(latitude: position.latitude, longitude: position.longitude);
      Firestore.instance
          .document(ref)
          .collection('members')
          .document(id)
          .updateData({'position': geoFirePoint.data});
    });
    print('member doc added');
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
