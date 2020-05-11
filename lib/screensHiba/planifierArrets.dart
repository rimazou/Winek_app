
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:winek/UpdateMarkers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'MapPage.dart';
import 'package:winek/auth.dart';
import 'package:winek/dataBaseSoum.dart';
import 'MapPage.dart';
class PlanifierArrets {

  String docId;

  PlanifierArrets({this.docId});

  //  .collection('Voyage')

  addArretsToSubCol(String p,double l,double lo) async{
    print("yeeeeeeeeeeeeeey");
    final databaseReference = Firestore.instance;
    final String colPath=p+'/PlanifierArrets';
    print(colPath);
    final String docPath=p+'/PlanifierArrets'+'/Arrets';
    print(docPath);
    var id=await AuthService().connectedID();
    String pseudo=await Database().getPseudo(id);

    print(pseudo);
    //on verifie si le doc existe
    final snap=await databaseReference.document(p).collection('PlanifierArrets').document('Arrets').get();
    //List<dynamic> listeArret = snap.data["planArrets"];
    print("ici");
    if(!snap.exists )
    {
      //await databaseReference.document(p).collection('PlanifierArrets').document('Arrets').setData({});
      print("champs non existant");
      await databaseReference.document(p).collection('PlanifierArrets').document("Arrets")
          .setData(
          {"planArrets":[{'latitude':l,'longitude':lo,'pseudo':pseudo}]}
      );
    }
    else
    {
      print("champs existant");
      await databaseReference.document(p).collection('PlanifierArrets').document("Arrets").updateData(
          {"planArrets":FieldValue.arrayUnion([
            {"latitude": l, "longitude": lo, "pseudo": pseudo}
          ]),}
      );
      print('ajout fait');
    }


    /*.setData(
      {"planArrets":[{'latitude':l,'longitude':lo,'pseudo':psd}]}
    );*/
  }

  //cette fonction est mise dans la classe de lemis a fin d'enlever le provider lors de l'ajout des markers
 /* Future getChanges(BuildContext context,String path_groupe) async {
    var id=await AuthService().connectedID();
    String pseud=await Database().getPseudo(id);
    print('path');
    print(path_groupe);

    Firestore.instance.document(path_groupe).collection('PlanifierArrets').document('Arrets')
        .snapshots(includeMetadataChanges: true)
        .listen((DocumentSnapshot documentSnapshot) async {

      print("object3");
      if (documentSnapshot.data != null) {
        if (documentSnapshot.data.containsKey('planArrets')) {
          List<dynamic> list = await documentSnapshot.data['planArrets'];
          print(list);

          print('markers');

          for (Map map in list) {

            print(map);
            MarkerId markerid = MarkerId(
                map['latitude'].toString() + map['longitude'].toString());
            Provider
                .of<UpdateMarkers>(context, listen: false)
                .markers
                .remove(markerid);
            Marker _marker = Marker(
              markerId: markerid,
              position: LatLng(map['latitude'], map['longitude']),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueCyan),
              infoWindow: InfoWindow(
                  title: map['pseudo'] + " a planifié(e) un arret ici"),
            );
            print("object4");
            Provider.of<UpdateMarkers>(context,listen:false).markers[markerid] = _marker;

            Provider.of<controllermap>(context).mapController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: LatLng(map['latitude'], map['longitude']),
                    zoom: 14.0)));
            // bool nouvelArret = documentSnapshot.data['planArret'];


            if (map['pseudo']!=pseud) {

              var vaaa = _AlertScreenState();
              vaaa.initState();
              await vaaa.showNotificationWithDefaultSound();

            }

          }

          print("object5");

        }
      }
    }

    );

  }*/


}


