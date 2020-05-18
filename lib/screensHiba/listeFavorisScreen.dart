import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import '../dataBaseDounia.dart';
import 'package:provider/provider.dart';
import 'listeFavoris.dart';
import '../main.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:ui';
import 'dart:io';

final GlobalKey<ScaffoldState> _scaffoldfavKey = new GlobalKey<ScaffoldState>();

GoogleMapsPlaces _places =
GoogleMapsPlaces(apiKey: "AIzaSyBV4k4kXJRfG5RmCO3OF24EtzEzZcxaTrg");

class FavoritePlacesScreen extends StatefulWidget {
  static const String id = 'FavoritePlacesScreen';
  @override
  _FavoritePlacesScreenState createState() => _FavoritePlacesScreenState();
}

class _FavoritePlacesScreenState extends State<FavoritePlacesScreen> {


  _showSnackBar(String value, BuildContext) {
    _scaffoldfavKey.currentState.showSnackBar(SnackBar(
      content: new Text(
        value,
        style: TextStyle(
            color: Colors.white,
            fontSize: responsivetext(14.0),
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600),
      ),
      duration: new Duration(seconds: 2),
      action: new SnackBarAction(label: 'Ok', onPressed: () {
        print('press Ok on SnackBar');
      }),
    )
    );
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
            backgroundColor: Colors.white,
            key: _scaffoldfavKey,
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
                        fontSize: responsivetext(20),
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF389490),
                        fontFamily: 'Montserrat-Bold',
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                  Container(
                    height: responsiveheight(450.0),
                    width: responsivewidth(350.0),
                    padding: EdgeInsets.symmetric(
                        horizontal: responsivewidth(10),
                        vertical: responsiveheight(10)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          responsiveradius(10, 1)),
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
                    iconSize: responsivewidth(35),
                    onPressed: () async {
                      try {
                        final result = await InternetAddress.lookup(
                            'google.com');
                        var result2 = await Connectivity().checkConnectivity();
                        var b = (result2 != ConnectivityResult.none);

                        if (b && result.isNotEmpty &&
                            result[0].rawAddress.isNotEmpty) {
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
                        _showSnackBar(
                            'Vérifiez votre connexion internet', context);
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
    var placeId = p.placeId;
    String placeIdToString = "$placeId";


    double lat = detail.result.geometry.location.lat;
    double lng = detail.result.geometry.location.lng;
    Geoflutterfire g = Geoflutterfire();
    GeoFirePoint gp = g.point(latitude: lat, longitude: lng);
    DataBaseFavoris().favorisUpdateData(gp, placeIdToString);
  }
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

void onError(PlacesAutocompleteResponse response) {
  homeScaffoldKey.currentState.showSnackBar(
    SnackBar(content: Text(response.errorMessage)),
  );
}