import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:geocoder/geocoder.dart' as coord;
import 'package:winek/main.dart';
//import 'package:winek/dataBaseDounia.dart';

import 'package:provider/provider.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:ui';
import 'dart:io';
import 'package:winek/auth.dart';
import 'package:winek/dataBaseDounia.dart';

GoogleMapsPlaces _places =
GoogleMapsPlaces(apiKey: "AIzaSyBV4k4kXJRfG5RmCO3OF24EtzEzZcxaTrg");

class FavorisList extends StatefulWidget {
  @override
  _FavorisListState createState() => _FavorisListState();
}

class _FavorisListState extends State<FavorisList> {
  Geoflutterfire g = Geoflutterfire();
  String placeName = "  ";
  String placeAddress = "  ";

  Future<Map<dynamic,dynamic>> getplace (String placeid) async {
    PlacesDetailsResponse place =
    await _places.getDetailsByPlaceId(placeid);
    final placeDetail = place.result;
    this.placeName = "${placeDetail.name}";
    this.placeAddress = "${placeDetail.formattedAddress}";
    Map map ={'name': placeName , 'adr': placeAddress};

    return map;

  }


  @override
  Widget build(BuildContext context) {
    final favoris = Provider.of<List<dynamic>>(context);
    int count;
    if (favoris != null) {
      count = favoris.length;
    } else {
      count = 0;
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (context, index) {
        return FutureBuilder(
          future: getplace(favoris[index]['placeid']) ,
          builder: (BuildContext context,AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return new Text('Loading....');
              default:
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                else {
                  var map = snapshot.data ?? {'name': 'hello' , 'adr': 'hiii'};
                  return FavorisTile(map['name'],map['adr'],favoris[index]['latitude'], favoris[index]['longitude'], favoris[index]['placeid']
                  );}}},);
      },
    );}

}


class FavorisTile extends StatefulWidget {
  String name ;
  String adr ;
  double latitude;
  double longitude;
  String placeId ;
  FavorisTile(String name , String adr ,double lt, double lg, String placeid) {
    this.name = name ;
    this.adr =adr ;
    this.latitude = lt;
    this.longitude = lg;
    this.placeId = placeid;

  }
  @override
  _FavorisTileState createState() => _FavorisTileState(name , adr,latitude, longitude,placeId);
}

class _FavorisTileState extends State<FavorisTile> {
  String addressToPrint = "  ";
  static Geoflutterfire geo = Geoflutterfire();
  GeoFirePoint geoP;
  double l1;
  double l2;
  double lat;
  double long;
  String placeName = "  ";
  String placeAddress = "  ";
  String geohsh;
  double latitude;
  double longitude;
  String placeId ;
  @override
  /*void initState() {
    placeAddress = '';
  }*/
/*Future init (double latd, double lng, String p)async {
  this.placeId = p;
  this.lat = latd;
  this.long = lng;
  //this.geohsh=str;
  l1 = this.lat;
  l2 = this.long;
  geoP = geo.point(latitude: l1, longitude: l2);
  convertPlaceId().then((String result) {
    setState(() {
      this.addressToPrint = result;
      print("address to print : ");
      print(this.addressToPrint);
    });
    print("Place's name : ");
    print(this.placeName);
    print("addresse : ");
    print(this.placeAddress);
  });

}*/

  _FavorisTileState(String name , String adr,double lt, double lg, String placeid) {
    this.placeName = name;
    this.placeAddress = adr;
    this.latitude = lt;
    this.longitude = lg;
    this.placeId = placeid;
    geoP = geo.point(latitude: lt, longitude: lg);
    print('HELLOOOOOOOOOOOOOOO $placeAddress, $latitude , $longitude , $placeId');
  }

  Future<String> convertPlaceId() async {
    PlacesDetailsResponse place =
    await _places.getDetailsByPlaceId(this.placeId);
    final placeDetail = place.result;
    this.placeName = "${placeDetail.name}";
    this.placeAddress = "${placeDetail.formattedAddress}";
    String adr = "${placeDetail.name} : ${placeDetail.formattedAddress}";
    print(
        "is it what i want ? : ${placeDetail.name}”, “${placeDetail.formattedAddress}");
    return adr;
  }

  Future<String> convertLatLong() async {
    final coordinates = new coord.Coordinates(this.lat, this.long);
    //final addresses = await coord.Geocoder.local.findAddressesFromCoordinates(coordinates);
    final addresses = await coord.Geocoder.google(
        "AIzaSyBV4k4kXJRfG5RmCO3OF24EtzEzZcxaTrg",
        language: "fr")
        .findAddressesFromCoordinates(coordinates);
    final first = addresses.first;
    this.addressToPrint =
    "${first.locality} : ${first.subLocality} : ${first.thoroughfare} : ${first.featureName} : ${first.addressLine}";

    String adr = "${first.featureName} : ${first.addressLine}";
    print(addressToPrint);
    print(
        "let's see more details: ${first.locality} : ${first.subLocality} : ${first.thoroughfare} ");

    return adr;
  }

  _showSnackBar(String value, BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(SnackBar(
      content: new Text(
        value,
        style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600),
      ),
      duration: new Duration(seconds: 2),
      //backgroundColor: Colors.green,
      action: new SnackBarAction(label: 'Ok', onPressed: () {
        print('press Ok on SnackBar');
      }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title:   Text(
          placeName,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize:responsivetext(12) ,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            //color: Color(0xff707070),
            color: Color(0xff5B5050),
          ),
        ),

        subtitle: Text(
          placeAddress,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize:responsivetext(10) ,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            //color: Color(0xff707070),
            color: Color(0xff5B5050),
          ),
        ),

        leading:  Icon(
          Icons.place,
          color: Color(0xff3B466B),
          size: 30,
        ),
        trailing: IconButton(
          onPressed: () async {
            try {
              final result = await InternetAddress.lookup('google.com');
              var result2 = await Connectivity().checkConnectivity();
              var b = (result2 != ConnectivityResult.none);

              if (b && result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

                await DataBaseFavoris().favorisDeleteData(this.geoP, this.placeId);
                //DataBaseFavoris().favorisIdDeleteData(this.placeid);
              }
            } on SocketException catch (_) {
              _showSnackBar('Vérifiez votre connexion internet', context);
            }
          },
          icon: Icon(Icons.remove_circle_outline),
          color: Color(0xff389490),
          iconSize: 30,
        ),
      ),
    );

  }
}