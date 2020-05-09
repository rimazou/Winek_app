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

  // static final currentUser = 'oHFzqoSaM4RUDpqL9UF396aTCf72';
  // static final currentUser = 'J2XLzfTvGSaauvH38q4Z6OexQRr1';
  Future<void> getConnectedId() async {
    var connectedUser = await authService.connectedID();
    // final FirebaseUser user1 = await auth.currentUser();
    user = "$connectedUser";
    //  pseud=user1.uid;
    print("currentUser : ");
    print(user);
  }

  setCurrentUser() {
    getConnectedId();
    this.currentUser = user;
    print('done');
  }

  setPseudo() {
    getConnectedId();
    this.psd = pseud;
    print('done');
  }

  // GeoFirePoint geoPoint ;
  double lat;
  double long;
  DataBaseFavoris({this.lat, this.long});
  //GeoFirePoint geoPoint=geo.Point(latitude:lati,longitude:longi);
  // final String pseudo ;
  final CollectionReference userCollection =
      Firestore.instance.collection('Utilisateur');

  Future favorisUpdateData(GeoFirePoint geop, String id) async {
    // ajouter un amis a la liste de current
    // getConnectedId();
    setCurrentUser();
    return await userCollection.document(currentUser).updateData({
      "favoris": FieldValue.arrayUnion([
        {'latitude': geop.latitude, "longitude": geop.longitude, "placeid": id}
      ]),
    });
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
    // ajouter un amis a la liste de current
    // getConnectedId();
    // setPseudo();
    setCurrentUser();
    print("object");
    var pseudoo = await AuthService().connectedID();
    print("object2");
    return await userCollection.document(currentUser).updateData({
      "arrets": FieldValue.arrayUnion([
        {"latitude": lat, "longitude": long, "pseudo": "hiba1"}
      ]),
    });
  }

  Stream<List<dynamic>> get getlistfavoris {
    // String id = await authService.connectedID();
    // getConnectedId();
    //print(this.currentUser);
    setCurrentUser();
    return userCollection.document(currentUser).snapshots().map((snap) {
      print('gonna copy dataaaaaaaaaaaaaaaa');

      List<dynamic> listfavoris = snap.data["favoris"];
      print(listfavoris);
      print('liiiiiiiiiist');
      if (listfavoris != null) {
        return listfavoris;
      }

      return [];
    });
    //return[];
  }
/*
  Future<List<dynamic>> listfavoris()async{
     String id = await authService.connectedID() ;
      return  userCollection.document(id).get().then((snap){
      if (snap.data['favoris'] =! null){
        return List<dynamic>.from(snap.data['favoris']);
      }
      return[];
    });
  } */
}
