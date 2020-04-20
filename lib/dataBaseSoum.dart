import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'classes.dart';
import 'package:winek/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  String id;
  //static final  currentUser = AuthService().connectedID().toString() ;
  static final currentUser = 'SckmOFjdeLDM3LTb4QK2';
  Database({this.id});

  final CollectionReference userCollection =
      Firestore.instance.collection('Utilisateur');

  Future userUpdateData(String current) async {
    // ajouter un amis a la liste de current
    return await userCollection.document(current).updateData({
      "amis": FieldValue.arrayUnion([id])
    });
  }

  Future userDeleteData(String current) async {
    // supprimer une invit de pseudo de la liste de current
    return await userCollection.document(current).updateData({
      "invitation": FieldValue.arrayRemove([id])
    });
  }

  Future invitUpdateData(String current) async {
    // ajouter une invit de pseudo a la liste de current
    return await userCollection.document(current).updateData({
      "invitation": FieldValue.arrayUnion([id])
    });
  }

  Future friendDeleteData(String current) async {
    // supprimer un lami pseudo de la liste de current
    return await userCollection.document(current).updateData({
      "amis": FieldValue.arrayRemove([id])
    });
  }

  List<String> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return doc.documentID;
    }).toList();
  }

  Stream<List<String>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<List<String>> get friends {
    return userCollection.document(id).snapshots().map((snap) {
      return snap.data['amis'].cast<String>();
    });
  }

  Stream<List<String>> get friendRequest {
    return userCollection.document(currentUser).snapshots().map((snap) {
      return snap.data['invitation'].cast<String>();
    });
  }

  String getPseudo(String id) {
    String name = 'marche pas';
    userCollection.document(id).snapshots().listen((docSnap) {
      if (docSnap != null) {
        name = docSnap.data['pseudo'];
      }
    });
    return name;
  }
}
