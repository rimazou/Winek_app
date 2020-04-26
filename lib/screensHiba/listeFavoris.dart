import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:geocoder/geocoder.dart' as coord;
import '../DataBaseDounia.dart';
import 'package:provider/provider.dart';
import 'package:geocoder/geocoder.dart' ;
import 'package:geoflutterfire/geoflutterfire.dart' ;

class FavorisList extends StatefulWidget {
  @override
  _FavorisListState createState() => _FavorisListState();
}

class _FavorisListState extends State<FavorisList> {
 Geoflutterfire g = Geoflutterfire();

  @override
  Widget build(BuildContext context) {
    final favoris = Provider.of<List<dynamic>>(context);
    int count ;
    if(favoris != null) {count = favoris.length;}
    
    else{count=0;}
    //print('oooooooooooooooooooo$count');
    return ListView.builder(
      shrinkWrap: true,
      itemCount:  count,
      itemBuilder: (context, index) {
        return FavorisTile(
         //geopointfav: favoris[index]['geopoint'],
         favoris[index]['geopoint'].latitude,
         favoris[index]['geopoint'].longitude 
          , favoris[index]['geohash']
          //addressToPrint: FavorisTile().convertLatLong().then(String),
          );
      },
    );
    
  }
}
 class FavorisTile extends StatefulWidget
 {
   double latitude;
   double longitude;
   String hsh;
  FavorisTile(double latit,double longit,String hash){
    this.latitude=latit;
    this.longitude=longit;
    this.hsh=hash;
  }
  @override
  _FavorisTile createState() => _FavorisTile(latitude,longitude,hsh);
 }


class _FavorisTile extends State<FavorisTile>{

 String addressToPrint="";
 static Geoflutterfire geo = Geoflutterfire();
GeoFirePoint geoP;
static double l1;
static double l2;
double lat;
double long;
  /*LatLng pos=new LatLng( lat,long);
  FavorisTile({this.lat,this.long});*/
  String geohsh;
  //Geoflutterfire gp=Geoflutterfire();
  //GeoFirePoint geopointfav;
  _FavorisTile(double lati,double longi,String str)
  {
    this.lat=lati;
    this.long=longi;
    this.geohsh=str;
    l1=this.lat;
    l2=this.long;
    geoP=geo.point(latitude: l1, longitude: l2) ; 
    convertLatLong().then((String result)
    {
      setState(() {
        this.addressToPrint=result;
      });

    }
    );
  }

   Future<String> convertLatLong() async{
        
       
        final coordinates = new coord.Coordinates(this.lat,this.long);
        //final addresses = await coord.Geocoder.local.findAddressesFromCoordinates(coordinates);
        final addresses = await coord.Geocoder.google("AIzaSyBV4k4kXJRfG5RmCO3OF24EtzEzZcxaTrg",language:"fr").findAddressesFromCoordinates(coordinates);
        final first = addresses.first;

        this.addressToPrint="${first.locality} : ${first.subLocality} : ${first.thoroughfare} : ${first.featureName} : ${first.addressLine}";
  
    String adr="${first.featureName} : ${first.addressLine}";
           print(addressToPrint);
          print("let's see more details: ${first.locality} : ${first.subLocality} : ${first.thoroughfare} ");
         
          print('hola');
    
      return adr;
        
    }

    /*String convertToString(double latit,double longi)
    {
        convertLatLong(latit, longi).then((String result)
        {
           final adr=result;
           this.addressToPrint=result;
          print('result : $result');
            print('adrToPrint1: ');
        print(this.addressToPrint);
        return adr;
        }
        );
        jso
        print('adrToPrint2: ');
        print(this.addressToPrint);
        return this.addressToPrint ;
    }*/

  
  @override
  Widget build(BuildContext context) {
  return Card(
      //child:FutureBuilder(
        child:
         ListTile(
        title: Text(
         addressToPrint,
          style: TextStyle(
            fontSize: 13,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            //color: Color(0xff707070),
            color: Color(0xff000000),
          ),
        ),
        leading: Icon(
          Icons.place,
          color: Color(0xff3B466B),
          size: 30,
        ),
        trailing: IconButton(
          onPressed: ()
          {
          DataBaseFavoris().favorisDeleteData(this.geoP);
          },
          icon: Icon(Icons.remove_circle_outline),
          color: Color(0xff389490),
          iconSize: 30,
        ),
      ),
    );
  }
}



