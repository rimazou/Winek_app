import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'classes.dart';

class Database {
  final String pseudo;

  Database({this.pseudo});

  final CollectionReference userCollection =
      Firestore.instance.collection('Utilisateur');

  Future userUpdateData(String current) async {
    // ajouter un amis a la liste de current
    return await userCollection.document(current).updateData({
      "amis": FieldValue.arrayUnion([pseudo])
    });
  }

  Future userDeleteData(String current) async {
    // supprimer une invit de pseudo de la liste de current
    return await userCollection.document(current).updateData({
      "invitation": FieldValue.arrayRemove([pseudo])
    });
  }

  Future invitUpdateData(String current) async {
    // ajouter une invit de pseudo a la liste de current
    return await userCollection.document(current).updateData({
      "invitation": FieldValue.arrayUnion([pseudo])
    });
  }

  Future friendDeleteData(String current) async {
    // supprimer un lami pseudo de la liste de current
    return await userCollection.document(current).updateData({
      "amis": FieldValue.arrayRemove([pseudo])
    });
  }

  List<Utilisateur> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Utilisateur(pseudo: doc.data['pseudo'] ?? '');
    }).toList();
  }

  Stream<List<Utilisateur>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<List<String>> get friends {
    return userCollection.document('asma').snapshots().map((snap) {
      return snap.data['amis'].cast<String>();
    });
  }

  Stream<List<String>> get friendRequest {
    return userCollection.document('asma').snapshots().map((snap) {
      return snap.data['invitation'].cast<String>();
    });
  }
}
