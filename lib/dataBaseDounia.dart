import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'package:geocoder/geocoder.dart' as coord;
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';
import 'package:winek/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:winek/auth.dart';

import 'auth.dart';

class DataBaseFavoris {
  String id;
  static String user;
  static String pseud;
  String psd;
  String currentUser;

  Future<void> getConnectedId() async {
    var connectedUser = await authService.connectedID();
    user = "$connectedUser";
  }

  setCurrentUser() {
    getConnectedId();
    this.currentUser = user;
  }

  setPseudo() {
    getConnectedId();
    this.psd = pseud;
  }

  double lat;
  double long;
  DataBaseFavoris({this.lat, this.long});

  final CollectionReference userCollection =
      Firestore.instance.collection('Utilisateur');

  Future favorisUpdateData(GeoFirePoint geop, String id) async {
    setCurrentUser();
    final snap = await userCollection.document(currentUser).get();
    if (snap.data['favoris'] == null) {
      return await userCollection.document(currentUser).updateData({
        "favoris": [
          {
            'latitude': geop.latitude,
            "longitude": geop.longitude,
            "placeid": id
          }
        ]
      });
    }
    else {
      return await userCollection.document(currentUser).updateData({
        "favoris": FieldValue.arrayUnion([
          {
            'latitude': geop.latitude,
            "longitude": geop.longitude,
            "placeid": id
          }
        ]),
      });
    }
  }

  Future favorisDeleteData(GeoFirePoint g, String id) async {
    // supprimer une invit de pseudo de la liste de current
    //getConnectedId();
    setCurrentUser();
    return await userCollection.document(currentUser).updateData({
      "favoris": FieldValue.arrayRemove([
        {"latitude": g.latitude, "longitude": g.longitude, "placeid": id}
      ]),
    });
  }

  Future arretUpdateData(double lat, double long) async {
    setCurrentUser();
    var pseudoo = await AuthService().connectedID();
    return await userCollection.document(currentUser).updateData({
      "arrets": FieldValue.arrayUnion([
        {"latitude": lat, "longitude": long, "pseudo": "hiba1"}
      ]),
    });
  }

  Stream<List<dynamic>> get getlistfavoris {
    setCurrentUser();
    return userCollection.document(currentUser).snapshots().map((snap) {

      List<dynamic> listfavoris = snap.data["favoris"];
      if (listfavoris != null) {
        return listfavoris;
      }

      return [];
    });
  }

}
