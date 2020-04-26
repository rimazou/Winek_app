import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';
import 'package:geocoder/geocoder.dart' as coord;
import 'package:geoflutterfire/geoflutterfire.dart' ;
import 'package:provider/provider.dart';

class DataBaseFavoris {
String id;
//static final currentUser = 'RtHNrx8VZTgm0FbenwHJlYg6crN2';
static final currentUser = 'oHFzqoSaM4RUDpqL9UF396aTCf72';
 // GeoFirePoint geoPoint ;
    double lat;
   double long;
  DataBaseFavoris({this.lat,this.long});

 //GeoFirePoint geoPoint=geo.Point(latitude:lati,longitude:longi);
 // final String pseudo ;


   
  final CollectionReference userCollection = Firestore.instance.collection('Utilisateur');

  Future favorisUpdateData(GeoFirePoint geop) async 
  {
    // ajouter un amis a la liste de current
    print('not yeeeeeeeeet');
    return await userCollection.document(currentUser).updateData({ 
      "favoris": FieldValue.arrayUnion([geop.data])
     
    });
  }

    Future favorisDeleteData(GeoFirePoint g) async {
    // supprimer une invit de pseudo de la liste de current
    return await userCollection.document(currentUser).updateData({
      "favoris": FieldValue.arrayRemove([g.data])
    });
  }




 Stream<List<dynamic>> get getlistfavoris {
    // String id = await authService.connectedID();
     return userCollection.document(currentUser).snapshots().map((snap){
       print('gonna copy dataaaaaaaaaaaaaaaa');
      
           GeoFirePoint g;
       List<dynamic> listfavoris=snap.data['favoris'];
       print(listfavoris);
       print('liiiiiiiiiist');
       return listfavoris;
     });
  
   }

}

