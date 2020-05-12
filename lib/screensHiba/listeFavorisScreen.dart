import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import '../dataBaseDounia.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'listeFavoris.dart';
import '../main.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:winek/auth.dart';
import 'dart:ui';
import 'dart:io';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

GoogleMapsPlaces _places =
GoogleMapsPlaces(apiKey: "AIzaSyBV4k4kXJRfG5RmCO3OF24EtzEzZcxaTrg");

class FavoritePlacesScreen extends StatefulWidget {
  static const String id = 'FavoritePlacesScreen';
  @override
  _FavoritePlacesScreenState createState() => _FavoritePlacesScreenState();
}

class _FavoritePlacesScreenState extends State<FavoritePlacesScreen> {
//static final currentUser = 'oHFzqoSaM4RUDpqL9UF396aTCf72';


  _showSnackBar(String value) {
    final snackBar = new SnackBar(
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
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<dynamic>>.value(
      value: DataBaseFavoris().getlistfavoris,
      catchError: (_, err) => null,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            /* appBar: AppBar(
            backgroundColor: Colors.white30,
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Colors.black54,),
            actions: <Widget>[ IconButton(
              onPressed: () {
               // Navigator.pushNamed(context, FriendRequestListScreen.id);
              },
              icon: Icon(Icons.arrow_back),
              color: Color(0xFF707070),
              iconSize: 35.0,),],
          ),*/
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
                        fontSize: responsivetext(20),
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF389490),
                        fontFamily: 'Montserrat-Bold',
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                  Container(
                    height: 450.0,
                    width: 350.0,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFD0D8E2),
                    ),
                    child: FavorisList(),
                  ),
                  Spacer(flex: 1),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFF389490),
                    ),
                    iconSize: 35,
                    onPressed: () async {
                      try {
                        final result = await InternetAddress.lookup(
                            'google.com');
                        var result2 = await Connectivity().checkConnectivity();
                        var b = (result2 != ConnectivityResult.none);

                        if (b && result.isNotEmpty &&
                            result[0].rawAddress.isNotEmpty) {
                          // show input autocomplete with selected mode
                          // then get the Prediction selected
                          //Prediction c= await PlacesDetailsResponse(status, errorMessage, r, htmlAttributions)
                          Prediction p = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: "AIzaSyBV4k4kXJRfG5RmCO3OF24EtzEzZcxaTrg",
                            onError: onError,
                            mode: Mode.overlay,
                            language: "fr",
                            components: [Component(Component.country, "DZ")],
                          );

                          displayPrediction(p);
                        }
                      } on SocketException catch (_) {
                        _showSnackBar('Vérifiez votre connexion internet');
                      }
                    },
                  ),
                  Spacer(
                    flex: 1,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<Null> displayPrediction(Prediction p) async {
  if (p != null) {
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    //final placeDetail=p.result;
    var placeId = p.placeId;
    String placeIdToString = "$placeId";
    //DataBaseFavoris().favorisIdUpdateData(placeIdToString);
    print('Place id : $placeId');

    double lat = detail.result.geometry.location.lat;
    double lng = detail.result.geometry.location.lng;
    //stockage du geopoint dans la bdd champs "favoris"
    Geoflutterfire g = Geoflutterfire();
    GeoFirePoint gp = g.point(latitude: lat, longitude: lng);
    DataBaseFavoris().favorisUpdateData(gp, placeIdToString);
    /* mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
          LatLng(lat,lng),
          zoom: 14.0)));*/
    print(lat);
    print(lng);
  }
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

void onError(PlacesAutocompleteResponse response) {
  homeScaffoldKey.currentState.showSnackBar(
    SnackBar(content: Text(response.errorMessage)),
  );
}
/*Future<Null> showDetailPlace(String placeId,BuildContext context) async {
if (placeId != null) {
Navigator.push(
context,
MaterialPageRoute(builder: (context) => PlaceDetailWidget(placeId)),
);
}*/