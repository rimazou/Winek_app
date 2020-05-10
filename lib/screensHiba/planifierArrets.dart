
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
  Future getChanges(BuildContext context,String path_groupe) async {
    var id=await AuthService().connectedID();
    String pseud=await Database().getPseudo(id);
    print('path');
    print(path_groupe);

    Firestore.instance.document(path_groupe).collection('PlanifierArrets').document('Arrets')
        .snapshots(includeMetadataChanges: true)
        .listen((DocumentSnapshot documentSnapshot) async {


      /*Firestore.instance.document(path_groupe)
        .snapshots(includeMetadataChanges: true)
        .listen((DocumentSnapshot documentSnapshot) async {*/

      /*  documentSnapshot.data.forEach((key, value) {
        print(key);
        print(value);
      });
    });*/

      print("object3");
      if (documentSnapshot.data != null) {
        if (documentSnapshot.data.containsKey('planArrets')) {
          List<dynamic> list = documentSnapshot.data['planArrets'];
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
            Provider.of<UpdateMarkers>(context).markers[markerid] = _marker;
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

  }


}


class AlertScreen extends StatefulWidget {
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('app_icon');
    var ios = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectedNotification);
  }

  Future onSelectedNotification(String payload) {
    debugPrint('payload : $payload');
    //TODO: je montre la liste des alerte recus (set state index = 3) ou j'epingle lalerte
    setState(() {
      //stackIndex = 3;
    });
    /*showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Color(0xFFd0d8e2),
          title: Text('Notification'),
          content: Text('heeeeeeeeeeey'),
        );
      },
    );*/
  }

  Future showNotificationWithDefaultSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Un nouvel arrêt a été planifier',
      'Clickez pour en savoir plus',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
  //------------------------------------

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
