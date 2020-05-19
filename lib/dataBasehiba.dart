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

  Future<bool> updategroupename(String ref, String nom, String nvnom) async {
    Map grp = {'chemin': ref, 'nom': nom};
    await Firestore.instance
        .collection('UserGrp')
        .getDocuments()
        .then((QuerySnapshot data) async {
      for (var doc in data.documents) {
        // data.documents.forEach((doc) {
        List<dynamic> list = doc.data['groupes'];
        if (list != null) {
          for (Map map in list) {
            if (map['chemin'] == ref) {
              await doc.reference.updateData({
                'groupes': FieldValue.arrayRemove([grp]),
              });
              await doc.reference.updateData({
                'groupes': FieldValue.arrayUnion([
                  {'chemin': ref, 'nom': nvnom}
                ]),
              });
            }
          }
        }
      }
    });
    await Firestore.instance
        .collection('UserGrp')
        .getDocuments()
        .then((QuerySnapshot data) async {
      for (var doc in data.documents) {
        // data.documents.forEach((doc)  {
        List<dynamic> list = doc.data['invitations'];
        if (list != null) {
          for (Map map in list) {
            if (map['chemin'] == ref) {
              await doc.reference.updateData({
                'invitations': FieldValue.arrayRemove([grp]),
              });
              await doc.reference.updateData({
                'invitations': FieldValue.arrayUnion([
                  {'chemin': ref, 'nom': nvnom}
                ]),
              });
            }
          }
        }
      }
    });

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
        .then((QuerySnapshot data) async {
      for (var doc in data.documents) {
        // data.documents.forEach((doc)  {
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
      }
    });
    await Firestore.instance
        .collection('UserGrp')
        .getDocuments()
        .then((QuerySnapshot data) async {
      for (var doc in data.documents) {
        //data.documents.forEach((doc)  {
        List<dynamic> list = doc.data['invitations'];
        if (list != null) {
          for (Map map in list) {
            if (map['chemin'] == ref) {
              await doc.reference.updateData({
                'invitations': FieldValue.arrayRemove([grp]),
              });
            }
          }
        }
      }
    });
    await Firestore.instance.document(ref).delete();
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
    try {
      Firestore.instance.collection('UserGrp').document(id).updateData({
        'groupes': FieldValue.arrayRemove([grp]),
      });
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
    Map grp = {'chemin': ref, 'nom': nom};
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
      'arrive': false,
    });
    GeoPoint position;
    GeoFirePoint geoFirePoint;
    Firestore.instance
        .collection('Utilisateur')
        .document(id)
        .snapshots(includeMetadataChanges: true)
        .listen((DocumentSnapshot documentSnapshot) {
      position = documentSnapshot.data['location']['geopoint'];

      geoFirePoint =
          geo.point(latitude: position.latitude, longitude: position.longitude);
      Firestore.instance
          .document(ref)
          .collection('members')
          .document(id)
          .updateData({'position': geoFirePoint.data});
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
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('UserGrp')
        .document(user['id'])
        .get();
    if (querySnapshot.exists && querySnapshot.data.containsKey('invitations')) {
      return List<Map<dynamic, dynamic>>.from(
          querySnapshot.data['invitations']);
    }
    return [];
  }
}
