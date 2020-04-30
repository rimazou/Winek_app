import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'package:geocoder/geocoder.dart' as coord;
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:provider/provider.dart';
import 'package:winek/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBaseFavoris {
  String id;
  String currentUser;
  //static final currentUser = 'oHFzqoSaM4RUDpqL9UF396aTCf72';
              Future<void> getConnectedId() async {
              var connectedUser =await authService.connectedID();
              this.currentUser="$connectedUser";
              print("currentUser : " );
              print(currentUser);

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
    getConnectedId();
    return await userCollection.document(currentUser).updateData({
      "favoris": FieldValue.arrayUnion([
        {'latitude': geop.latitude, "longitude": geop.longitude, "placeid": id}
      ]),
    });
  }

  Future favorisDeleteData(GeoFirePoint g, String id) async {
    // supprimer une invit de pseudo de la liste de current
getConnectedId();
    return await userCollection.document(currentUser).updateData({
      "favoris": FieldValue.arrayRemove([
        {"latitude": g.latitude, "longitude": g.longitude, "placeid": id}
      ]),
    });
  }

  Future favorisIdUpdateData(String id) async {
    // ajouter un amis a la liste de current
    print('not yeeeeeeeeet');
    return await userCollection.document(currentUser).updateData({
      "favorisPlaceId": FieldValue.arrayUnion([id])
    });
  }

  Future favorisIdDeleteData(String id) async {
    // supprimer une invit de pseudo de la liste de current
    return await userCollection.document(currentUser).updateData({
      "favorisPlaceId": FieldValue.arrayRemove([id])
    });
  }

  Stream<List<dynamic>> get getlistfavoris {
    // String id = await authService.connectedID();
    getConnectedId();
    return userCollection.document(currentUser).snapshots().map((snap) {
      print('gonna copy dataaaaaaaaaaaaaaaa');

      List<dynamic> listfavoris = snap.data['favoris'];
      print(listfavoris);
      print('liiiiiiiiiist');
      if (listfavoris != null) {
        return listfavoris;
      }
      return [];
    });
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
