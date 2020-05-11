import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:winek/main.dart';
import '../dataBaseDounia.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:winek/auth.dart';
import 'package:geocoder/geocoder.dart' as coord;

GoogleMapsPlaces _places =
    GoogleMapsPlaces(apiKey: "AIzaSyBV4k4kXJRfG5RmCO3OF24EtzEzZcxaTrg");

class GetDestination extends StatefulWidget {
  static const String id = 'GetDestination';
  @override
  _GetDestinationState createState() => _GetDestinationState();
}

class _GetDestinationState extends State<GetDestination> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<dynamic>>.value(
      value: DataBaseFavoris().getlistfavoris,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
              child: Column(
                children: <Widget>[
                  Spacer(
                    flex: 1,
                  ),
                  Center(
                    child: Text(
                      'Endroits favoris',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w800,
                        color: secondarycolor,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                  Container(
                    height: 500.0,
                    width: 350.0,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFD0D8E2),
                    ),
                    child: FavorisList(),
                  ),
                  Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FavorisList extends StatefulWidget {
  @override
  _FavorisListState createState() => _FavorisListState();
}

class _FavorisListState extends State<FavorisList> {
  Geoflutterfire g = Geoflutterfire();

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
        return FavorisTile(
            //geopointfav: favoris[index]['geopoint'],
            favoris[index]['latitude'],
            favoris[index]['longitude'],
            // favoris[index]['geohash'],

            favoris[index]['placeid']
            //addressToPrint: FavorisTile().convertLatLong().then(String),
            );
      },
    );
  }
}

class FavorisTile extends StatefulWidget {
  GeoFirePoint gp;
  double latitude;
  double longitude;
  String hsh;
  String placeId;
  FavorisTile(double lt, double lg, String placeid) {
    this.latitude = lt;
    this.longitude = lg;
    //this.hsh=hash;
    //this.gp=g;
    this.placeId = placeid;
  }
  @override
  _FavorisTile createState() => _FavorisTile(latitude, longitude, placeId);
}

class _FavorisTile extends State<FavorisTile> {
  String addressToPrint = "";
  static Geoflutterfire geo = Geoflutterfire();
  GeoFirePoint geoP;
  static double l1;
  static double l2;
  double lat;
  double long;
  String placeName;
  String placeAddress;
  String placeid;
  String geohsh;
  _FavorisTile(double latd, double lng, String p) {
    this.placeid = p;
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
  }

  Future<String> convertPlaceId() async {
    PlacesDetailsResponse place =
        await _places.getDetailsByPlaceId(this.placeid);
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

  @override
  void initState() {
    placeAddress = '';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Map<String, dynamic> m = {
            'latitude': lat,
            'longitude': long,
            'adresse': placeAddress,
          };
          Navigator.pop(context, m);
        },
        title: Text(
          placeAddress,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            //color: Color(0xff707070),
            color: Color(0xff5B5050),
          ),
        ),
        leading: Icon(
          Icons.place,
          color: Color(0xff3B466B),
          size: 30,
        ),
      ),
    );
  }
}
