import 'dart:io';
import 'dart:ui';
import 'package:winek/screensRima/profile_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:winek/main.dart';
import 'package:winek/screensRima/waitingSignout.dart';
import 'package:winek/screensSoum/friendsListScreen.dart';
import '../classes.dart';
import '../dataBasehiba.dart';
import 'list_grp.dart';
import 'nouveau_grp.dart';
import 'package:winek/auth.dart';
import 'listeFavorisScreen.dart';
import 'package:winek/UpdateMarkers.dart';
import 'package:provider/provider.dart';
import '../screensRima/profile_screen.dart';
import 'composants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:connectivity/connectivity.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'Aide.dart';
import 'planifierArrets.dart';
import 'package:winek/updateMarkers2.dart';
import 'package:winek/dataBaseSoum.dart';

//asma's variables
final _firestore = Firestore.instance;
String currentUser = 'ireumimweo';
String utilisateurID;
int stackIndex = 0;
String groupPath;
String Username;
String Userimage;
bool justReceivedAlert = false;
ValueNotifier valueNotifier = ValueNotifier(justReceivedAlert);

const kGoogleApiKey = "AIzaSyAnvTAPHqVvPr21Oeq8of-PANR_tEPLLO8";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
Databasegrp data = Databasegrp();

//google maps stuffs
//GoogleMapController mapController;
String searchAddr;

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final voyageScaffoldKey = GlobalKey<ScaffoldState>();
final longtermeScaffoldKey = GlobalKey<ScaffoldState>();

class controllermap extends ChangeNotifier {
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  searchandNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 10.0)));
    });
  }

  Future<Null> displayPredictionRecherche(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 13.0)));
    }
  }
}

void onErrorhome(PlacesAutocompleteResponse response) {
  homeScaffoldKey.currentState.showSnackBar(
    SnackBar(content: Text(response.errorMessage)),
  );
}

void onErrorvoyage(PlacesAutocompleteResponse response) {
  voyageScaffoldKey.currentState.showSnackBar(
    SnackBar(content: Text(response.errorMessage)),
  );
}

void onErrorlongterme(PlacesAutocompleteResponse response) {
  longtermeScaffoldKey.currentState.showSnackBar(
    SnackBar(content: Text(response.errorMessage)),
  );
}

class Home extends StatefulWidget {
  static const String id = 'map';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
//variables
  int index;
  bool _visible = true;
  Color c1 = const Color.fromRGBO(0, 0, 60, 0.8);
  Color c2 = const Color(0xFF3B466B);
  Color myWhite = const Color(0xFFFFFFFF);
  Map<MarkerId, Marker> markersAcceuil = <MarkerId, Marker>{};
  Marker _marker;
  GoogleMapController mapAccController;
//fin variables

  void _onMapCreatedAcc(GoogleMapController controller) {
    mapAccController = controller;
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);
    }
  }

  Size size;
  @override
  void initState() {
    Userimage =
        'https://firebasestorage.googleapis.com/v0/b/winek-70176.appspot.com/o/photos%2Flogo.png?alt=media&token=3103246d-243e-42ec-9368-cab992206d49';

    Username = '';
    index = 0;
  }

  _showSnackBarhome(String value, BuildContext context) {
    homeScaffoldKey.currentState.showSnackBar(SnackBar(
      content: new Text(
        value,
        style: TextStyle(
            color: Colors.white,
            fontSize: responsivetext(14.0),
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600),
      ),
      duration: new Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      //backgroundColor: Colors.green,
      action: new SnackBarAction(
          label: 'Ok',
          onPressed: () {
            print('press Ok on SnackBar');
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      key: homeScaffoldKey,
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: bottomNavBar,
      floatingActionButton: flaotButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            // trafficEnabled: true,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            mapToolbarEnabled: true,
            markers: Set<Marker>.of(markersAcceuil.values),
            onMapCreated: _onMapCreatedAcc,
            initialCameraPosition: CameraPosition(
              target: LatLng(36.7525000, 3.0419700),
              zoom: 11.0,
            ),
          ),
          IndexedStack(index: index, children: <Widget>[
            //index = 0 :
            ResearchBar,
            // the drawer, index=1
            Container(
              width: size.width,
              height: size.height,
              color: Color.fromRGBO(255, 255, 255, 0.5),
              child: Column(
                children: <Widget>[
                  Spacer(
                    flex: 1,
                  ),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          // _closeDrawer(context);
                          setState(() {
                            index = 0;
                          });
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Center(
                    child: Container(
                      height: responsiveheight(450),
                      width: responsivewidth(280),
                      //margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(responsiveradius(20, 1)),
                        color: primarycolor, //Color.fromRGBO(59, 70, 107, 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Spacer(
                            flex: 1,
                          ),
                          Container(
                            height: responsiveheight(80),
                            // MediaQuery.of(context).size.height * 0.1 * 0.65,
                            width: responsivewidth(80),
                            // MediaQuery.of(context).size.height * 0.1 * 0.65,
                            margin: EdgeInsets.symmetric(
                                horizontal: responsivewidth(4)),
                            child: CircleAvatar(
                              backgroundColor: Color(0xFFFFFFFF),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      responsiveradius(50, 1)),
                                  child: Image.network(Userimage)),
                            ),
                          ),
                          Center(
                            child: Text(
                              Username,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  fontSize: responsivetext(15),
                                  color: Colors.white),
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                ListTile(
                                  onTap: () async {
                                    try {
                                      final result =
                                          await InternetAddress.lookup(
                                              'google.com');
                                      var result2 = await Connectivity()
                                          .checkConnectivity();
                                      var b =
                                          (result2 != ConnectivityResult.none);

                                      if (b &&
                                          result.isNotEmpty &&
                                          result[0].rawAddress.isNotEmpty) {
                                        String id =
                                            await authService.connectedID();
                                        if (id != null) {
                                          DocumentSnapshot snapshot =
                                              await authService.userRef
                                                  .document(id)
                                                  .get();

                                          if (snapshot != null) {
                                            Utilisateur utilisateur =
                                                Utilisateur.fromdocSnapshot(
                                                    snapshot);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfileScreen(
                                                            utilisateur)));
                                          }
                                        }
                                      }
                                    } on SocketException catch (_) {
                                      _showSnackBarhome(
                                          'Vérifiez votre connexion internet',
                                          context);
                                    }
                                  },
                                  leading: Icon(
                                    Icons.playlist_add_check,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    "Compte",
                                    //strutStyle: ,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        color: myWhite,
                                        fontSize: 15),
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, FavoritePlacesScreen.id);
                                  },
                                  leading: Icon(Icons.star, color: myWhite),
                                  title: Text(
                                    "Favoris",
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        color: myWhite,
                                        fontSize: 15),
                                  ),
                                ),
                                ListTile(
                                  onTap: () async {
                                    try {
                                      final result =
                                          await InternetAddress.lookup(
                                              'google.com');
                                      var result2 = await Connectivity()
                                          .checkConnectivity();
                                      var b =
                                          (result2 != ConnectivityResult.none);

                                      if (b &&
                                          result.isNotEmpty &&
                                          result[0].rawAddress.isNotEmpty) {
                                        String currentUser =
                                            await AuthService().connectedID();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FriendsListScreen(
                                                        currentUser)));
                                      }
                                    } on SocketException catch (_) {
                                      _showSnackBarhome(
                                          'Vérifiez votre connexion internet',
                                          context);
                                    }
                                  },
                                  leading: Icon(
                                    Icons.group,
                                    color: myWhite,
                                  ),
                                  title: Text(
                                    "Liste d'amis",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        color: myWhite,
                                        fontSize: 15),
                                    //strutStyle: ,
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(context, AidePage.id);
                                  },
                                  leading: Icon(
                                    Icons.build,
                                    color: myWhite,
                                  ),
                                  title: Text(
                                    "Aide",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                      color: myWhite,
                                      fontSize: responsivetext(15),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    Provider.of<AuthService>(context,
                                            listen: false)
                                        .positionStream
                                        ?.cancel();
                                    Provider.of<UpdateMarkers>(context,
                                            listen: false)
                                        .stream
                                        ?.cancel();

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignoutWait()));
                                  },
                                  leading: Icon(
                                    Icons.directions_run,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    "Déconnecter",
                                    //strutStyle: ,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        color: myWhite,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 5,
                  ),
                ],
              ),
            ),
            //index = 2 : choix de groupe
            Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      //  _visible = !_visible;
                      index = 0;
                    });
                  },
                  child: Container(
                    height: size.height,
                    width: size.width,
                    color: Color.fromRGBO(255, 255, 255, 0.2),
                  ),
                ),
                Center(
                  child: Container(
                    height: responsiveheight(370),
                    width: responsivewidth(266),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(responsiveradius(10, 1)),
                        color: Color.fromRGBO(59, 70, 107, 0.5)),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Spacer(
                            flex: 1,
                          ),
                          Text("Créer un groupe ",
                              style: TextStyle(
                                fontSize: responsivetext(17),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              )),
                          Spacer(
                            flex: 1,
                          ),
                          GestureDetector(
                            onTap: () async {
                              try {
                                final result =
                                    await InternetAddress.lookup('google.com');
                                var result2 =
                                    await Connectivity().checkConnectivity();
                                var b = (result2 != ConnectivityResult.none);

                                if (b &&
                                    result.isNotEmpty &&
                                    result[0].rawAddress.isNotEmpty) {
                                  setState(() {
                                    index = 0;
                                  });

                                  Navigator.pushNamed(context, NvVoyagePage.id);
                                }
                              } on SocketException catch (_) {
                                _showSnackBarhome(
                                    'Vérifiez votre connexion internet',
                                    context);
                              }
                            },
                            child: Bouton(
                              icon: Icon(
                                Icons.directions_bus,
                                color: Color(0xff707070),
                                size: responsivewidth(75),
                              ),
                              contenu: Text(
                                "de voyage",
                                style: TextStyle(
                                    fontSize: responsivetext(14.0),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xff707070)),
                              ),
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          GestureDetector(
                            onTap: () async {
                              try {
                                final result =
                                    await InternetAddress.lookup('google.com');
                                var result2 =
                                    await Connectivity().checkConnectivity();
                                var b = (result2 != ConnectivityResult.none);

                                if (b &&
                                    result.isNotEmpty &&
                                    result[0].rawAddress.isNotEmpty) {
                                  setState(() {
                                    index = 0;
                                  });
                                  Navigator.pushNamed(
                                      context, NvLongTermePage.id);
                                }
                              } on SocketException catch (_) {
                                _showSnackBarhome(
                                    'Vérifiez votre connexion internet',
                                    context);
                              }
                            },
                            child: Bouton(
                              icon: Icon(
                                Icons.people,
                                color: Color(0xff707070),
                                size: responsivewidth(75),
                              ),
                              contenu: Text(
                                "a long terme",
                                style: TextStyle(
                                    fontSize: responsivetext(14.0),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xff707070)),
                              ),
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ],
      ),
    );
  }

  Widget get ResearchBar {
    return Positioned(
      left: size.width * 0.075,
      top: size.height * 0.04,
      // child: AnimatedOpacity(
      // opacity: _visible ? 1.0 : 0.0,
      //duration: Duration(milliseconds: 500),
      child: Container(
          height: size.height * 0.07,
          width: size.width * 0.85,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0), color: Colors.white),
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Color(0xFF3B466B),
                  ),
                  onPressed: () async {
                    try {
                      final result = await InternetAddress.lookup('google.com');
                      var result2 = await Connectivity().checkConnectivity();
                      var b = (result2 != ConnectivityResult.none);

                      if (b &&
                          result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        String id = await authService.connectedID();
                        String pseudo = await Firestore.instance
                            .collection('Utilisateur')
                            .document(id)
                            .get()
                            .then((doc) {
                          return doc.data['pseudo'];
                        });
                        String image = await Firestore.instance
                            .collection('Utilisateur')
                            .document(id)
                            .get()
                            .then((doc) {
                          return doc.data['photo'];
                        });
                        // _openDrawer(context);
                        setState(() {
                          Username = pseudo;
                          Userimage = image;
                          index = 1;
                          // _visible = !_visible;
                        });
                      }
                    } on SocketException catch (_) {
                      _showSnackBarhome(
                          'Vérifiez votre connexion internet', context);
                    }
                  },
                  iconSize: 30.0),
              Spacer(
                flex: 1,
              ),
              Center(
                child: Text(
                  'Recherche',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                    fontSize: responsivetext(15),
                    color: Color(0xff707070),
                  ),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Color(0xFF3B466B),
                  ),
                  onPressed: () async {
                    try {
                      final result = await InternetAddress.lookup('google.com');
                      var result2 = await Connectivity().checkConnectivity();
                      var b = (result2 != ConnectivityResult.none);

                      if (b &&
                          result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        // show input autocomplete with selected mode
                        // then get the Prediction selected
                        Prediction p = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: kGoogleApiKey,
                          onError: onErrorhome,
                          mode: Mode.overlay,
                          language: "fr",
                          components: [Component(Component.country, "DZ")],
                        );

                        Provider.of<controllermap>(context, listen: false)
                            .displayPredictionRecherche(p);
                      }
                    } on SocketException catch (_) {
                      _showSnackBarhome(
                          'Vérifiez votre connexion internet', context);
                    }
                  },
                  iconSize: 30.0),
            ],
          )),
    );
  }

  Widget get flaotButton {
    return
        //AnimatedOpacity(
        // opacity: _visible ? 1.0 : 0.0,
        //duration: Duration(milliseconds: 500),
        //child:
        FloatingActionButton(
      heroTag: null,
      backgroundColor: Color(0xFF389490),
      child: Icon(Icons.group_add, size: 32.0),
      onPressed: () {
        setState(() {
          index = 2;
          // _visible = !_visible;
        });
      },
      // ),
    );
    //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked;
  }

  Widget get bottomNavBar {
    return /*AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: */
        ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(40),
        topLeft: Radius.circular(40),
      ),
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Color(0xFF3B466B),
        notchMargin: 10,
        child: Container(
          height: responsiveheight(70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.group,
                      size: responsivewidth(32.0),
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      try {
                        final result =
                            await InternetAddress.lookup('google.com');
                        var result2 = await Connectivity().checkConnectivity();
                        var b = (result2 != ConnectivityResult.none);

                        if (b &&
                            result.isNotEmpty &&
                            result[0].rawAddress.isNotEmpty) {
                          setState(() {
                            index = 0;
                          });
                          Navigator.pushNamed(context, ListGrpPage.id);
                        }
                      } on SocketException catch (_) {
                        _showSnackBarhome(
                            'Vérifiez votre connexion internet', context);
                      }
                    },
                  ),
                ],
              ),

              // Right Tab bar icons

              MaterialButton(
                minWidth: responsivewidth(40),
                onPressed: () async {
                  try {
                    final result = await InternetAddress.lookup('google.com');
                    var result2 = await Connectivity().checkConnectivity();
                    var b = (result2 != ConnectivityResult.none);

                    if (b &&
                        result.isNotEmpty &&
                        result[0].rawAddress.isNotEmpty) {
                      Position position = await Geolocator().getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);

                      setState(() {
                        markersAcceuil.remove(MarkerId('markerrecentrer'));
                      });

                      MarkerId markerid = MarkerId('markerrecentrer');
                      String url;
                      var id = await authService.connectedID();
                      if (id != null) {
                        String pseudo = await Database().getPseudo(id);
                        await _firestore
                            .collection('Utilisateur')
                            .document(id)
                            .get()
                            .then((DocumentSnapshot ds) {
                          url = ds.data['photo'];
                        });
                        _marker = Marker(
                          markerId: markerid,
                          position:
                              LatLng(position.latitude, position.longitude),
                          icon: await Provider.of<UpdateMarkers>(context,
                                  listen: false)
                              .getMarkerIcon(url, Size(200.0, 200.0)),
                          infoWindow: InfoWindow(snippet: '$pseudo'),
                        );

                        setState(() {
                          markersAcceuil[markerid] = _marker;
                        });
                        mapAccController.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(
                                    position.latitude, position.longitude),
                                zoom: 13.0)));
                      }
                    }
                  } on SocketException catch (_) {
                    _showSnackBarhome(
                        'Vérifiez votre connexion internet', context);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      size: responsivewidth(32.0),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}

class MapVoyagePage extends StatefulWidget {
  Voyage groupe;
  String path;
  List<String> imagesUrl;
  MapVoyagePage(this.groupe, this.path, this.imagesUrl);

  @override
  _MapVoyagePageState createState() =>
      _MapVoyagePageState(groupe, path, imagesUrl);
}

class _MapVoyagePageState extends State<MapVoyagePage> {
  Voyage groupe;
  String path; // asma u use that path as docref
  Color c1 = const Color.fromRGBO(0, 0, 60, 0.8);
  Color c2 = const Color(0xFF3B466B);
  Color myWhite = const Color(0xFFFFFFFF);
  int index;
  List<String> imagesUrl;
  Map membreinfo;
  _MapVoyagePageState(this.groupe, this.path, this.imagesUrl);

  bool fermeture;

//asma variables2
  String alertePerso;
  bool _loading;
  final _controller = TextEditingController();

  //-----------------------

  @override
  void initState() {
    index = 0;
    Username = '';
    Userimage =
        'https://firebasestorage.googleapis.com/v0/b/winek-70176.appspot.com/o/photos%2Flogo.png?alt=media&token=3103246d-243e-42ec-9368-cab992206d49';

    membreinfo = {
      'pseudo': '',
      'image': '',
      'vitesse': Text(
        '0 km/h',
        overflow: TextOverflow.clip,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: responsivetext(13.0),
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
        ),
      ),
      'temps': Text(
        '0 min',
        overflow: TextOverflow.clip,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: responsivetext(14.0),
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
        ),
      ),
      'batterie': Text(
        '100%',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: responsivetext(10),
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
        ),
      ),
    };
    Firestore.instance
        .document(path)
        .collection('fermeture')
        .document('fermeture')
        .snapshots(includeMetadataChanges: true)
        .listen((DocumentSnapshot documentSnapshot) {
      fermeture = documentSnapshot.data['fermer'];
      if (fermeture) {
        setState(() {
          index = 4;
        });
      }
    });
  }

  _showSnackBar(String value, BuildContext context) {
    voyageScaffoldKey.currentState.showSnackBar(SnackBar(
      content: new Text(
        value,
        style: TextStyle(
            color: Colors.white,
            fontSize: responsivetext(14.0),
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600),
      ),
      duration: new Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      //backgroundColor: Colors.green,
      action: new SnackBarAction(
          label: 'Ok',
          onPressed: () {
            print('press Ok on SnackBar');
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> liste = new List();
    //  var it = groupe.membres.iterator;
    for (int i = 0; i < groupe.membres.length; i++) {
      liste.add(
        Padding(
          padding: EdgeInsets.all(7),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.1 * 0.65,
                width: MediaQuery.of(context).size.height * 0.1 * 0.65,
                margin: EdgeInsets.symmetric(horizontal: 4),
                child: CircleAvatar(
                  backgroundColor: Color(0xFFFFFFFF),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: GestureDetector(
                          onTap: () async {
                            try {
                              final result =
                                  await InternetAddress.lookup('google.com');
                              var result2 =
                                  await Connectivity().checkConnectivity();
                              var b = (result2 != ConnectivityResult.none);

                              if (b &&
                                  result.isNotEmpty &&
                                  result[0].rawAddress.isNotEmpty) {
                                GeoPoint point;
                                CameraUpdate cameraUpdate;
                                await Firestore.instance
                                    .document(path)
                                    .collection('members')
                                    .document(groupe.membres[i]['id'])
                                    .get()
                                    .then((DocumentSnapshot ds) {
                                  point = ds.data['position']['geopoint'];
                                });
                                LatLng latlng =
                                    new LatLng(point.latitude, point.longitude);
                                cameraUpdate =
                                    CameraUpdate.newLatLngZoom(latlng, 13);
                                Provider.of<controllermap>(context,
                                        listen: false)
                                    .mapController
                                    .animateCamera(cameraUpdate);
                                setState(() {
//zoum sur la personne, son id est dans
// groupe.membres[i]['id']
                                  membreinfo['pseudo'] =
                                      groupe.membres[i]['pseudo'];
                                  membreinfo['image'] = imagesUrl[i];

// membreinfo['vitesse']
                                  var vitesse;
                                  int vite = 0;
                                  membreinfo['vitesse'] = StreamBuilder(
                                    stream: _firestore
                                        .collection('Utilisateur')
                                        .document(groupe.membres[i]['id'])
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        vitesse = snapshot.data['vitesse'];
                                        if (vitesse != 0) {
                                          vite = (vitesse * 3.6).toInt();
                                        } else {
                                          vite = 0;
                                        }
                                        return Text(
                                          '$vite Km/h',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: responsivetext(13.0),
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  );

                                  double temps = 0;
                                  dynamic vts = 0;
                                  GeoPoint point;
                                  double distance;
                                  double t;
                                  int heure = 0;
                                  int min = 0;

                                  membreinfo['temps'] = StreamBuilder(
                                      stream: _firestore
                                          .collection('Utilisateur')
                                          .document(groupe.membres[i]['id'])
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          vts = snapshot.data['vitesse'];
                                          if (vts != 0) {
                                            point = snapshot.data['location']
                                                ['geopoint'];
                                            distance = Provider.of<
                                                        UpdateMarkers>(context,
                                                    listen: false)
                                                .calculateDistance(
                                                    point.latitude,
                                                    point.longitude,
                                                    groupe.destination_latitude,
                                                    groupe
                                                        .destination_longitude);
                                            temps = (distance * 1000) / vts;
                                            t = temps / 60;
                                            heure = (t ~/ 60).toInt();
                                            min = (t % 60).toInt();
                                          }
                                          return Text(
                                            '$heure h $min min',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          );
                                        }
                                        return Container();
                                      });

//membreinfo['batterie']
                                  membreinfo['batterie'] = StreamBuilder(
                                    stream: _firestore
                                        .collection('Utilisateur')
                                        .document(groupe.membres[i]['id'])
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          '${snapshot.data['batterie']}',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: responsivetext(10),
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  );
                                  index = 3;
                                });
                              }
                            } on SocketException catch (_) {
                              _showSnackBar(
                                  'Vérifiez votre connexion internet', context);
                            }
                          },
                          child: Image.network(imagesUrl[i]))),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    groupe.membres[i]['pseudo'],
                    //overflow:TextOverflow.fade,

                    //textScaleFactor: 0.4,
                    style: TextStyle(
                      fontFamily: 'MontSerrat',
                      fontSize: responsivetext(10),
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      extendBody: true,
      key: voyageScaffoldKey,
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            mapToolbarEnabled: true,
            onMapCreated: Provider.of<controllermap>(context, listen: false)
                ._onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(36.7525000, 3.0419700),
              zoom: 11.0,
            ),
            markers: Set<Marker>.of(
                Provider.of<UpdateMarkers>(context).markers.values),
          ),
          IndexedStack(index: index, children: <Widget>[
            //index = 0 :
            Stack(
              children: <Widget>[
                //recherche barre
                Positioned(
                  left: size.width * 0.075,
                  top: size.height * 0.04,
                  // child: AnimatedOpacity(
                  // opacity: _visible ? 1.0 : 0.0,
                  //duration: Duration(milliseconds: 500),
                  child: Container(
                      height: size.height * 0.07,
                      width: size.width * 0.85,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          color: Colors.white),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: Color(0xFF3B466B),
                              ),
                              onPressed: () async {
                                try {
                                  final result = await InternetAddress.lookup(
                                      'google.com');
                                  var result2 =
                                      await Connectivity().checkConnectivity();
                                  var b = (result2 != ConnectivityResult.none);

                                  if (b &&
                                      result.isNotEmpty &&
                                      result[0].rawAddress.isNotEmpty) {
                                    String id = await authService.connectedID();
                                    String pseudo = await Firestore.instance
                                        .collection('Utilisateur')
                                        .document(id)
                                        .get()
                                        .then((doc) {
                                      return doc.data['pseudo'];
                                    });
                                    String image = await Firestore.instance
                                        .collection('Utilisateur')
                                        .document(id)
                                        .get()
                                        .then((doc) {
                                      return doc.data['photo'];
                                    });
                                    // _openDrawer(context);
                                    setState(() {
                                      Username = pseudo;
                                      Userimage = image;
                                      index = 1;
                                      // _visible = !_visible;
                                    });
                                  }
                                } on SocketException catch (_) {
                                  _showSnackBar(
                                      'Vérifiez votre connexion internet',
                                      context);
                                }
                              },
                              iconSize: 30.0),
                          Spacer(
                            flex: 1,
                          ),
                          Center(
                            child: Text(
                              'Recherche',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat',
                                fontSize: responsivetext(15),
                                color: Color(0xff707070),
                              ),
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Color(0xFF3B466B),
                              ),
                              onPressed: () async {
                                try {
                                  final result = await InternetAddress.lookup(
                                      'google.com');
                                  var result2 =
                                      await Connectivity().checkConnectivity();
                                  var b = (result2 != ConnectivityResult.none);

                                  if (b &&
                                      result.isNotEmpty &&
                                      result[0].rawAddress.isNotEmpty) {
                                    // show input autocomplete with selected mode
                                    // then get the Prediction selected
                                    Prediction p =
                                        await PlacesAutocomplete.show(
                                      context: context,
                                      apiKey: kGoogleApiKey,
                                      onError: onErrorvoyage,
                                      mode: Mode.overlay,
                                      language: "fr",
                                      components: [
                                        Component(Component.country, "DZ")
                                      ],
                                    );

                                    Provider.of<controllermap>(context,
                                            listen: false)
                                        .displayPredictionRecherche(p);
                                  }
                                } on SocketException catch (_) {
                                  _showSnackBar(
                                      'Vérifiez votre connexion internet',
                                      context);
                                }
                              },
                              iconSize: 30.0),
                        ],
                      )),
                ),
                //liste of members
                Positioned(
                  bottom: 4,
                  left: MediaQuery.of(context).size.width * 0.025,
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                        //HEEEEre grey container
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(responsiveradius(10, 1)),
                            color: Color(0xFF7888a0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey,
                                blurRadius: 3.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.0, 2.0),
                              )
                            ],
                          ),
                          child: SizedBox(
                            height: 10.0,
                            width: 60.0,
                          ),
                        ),
                        onPressed: () async {
                          try {
                            final result =
                                await InternetAddress.lookup('google.com');
                            var result2 =
                                await Connectivity().checkConnectivity();
                            var b = (result2 != ConnectivityResult.none);

                            if (b &&
                                result.isNotEmpty &&
                                result[0].rawAddress.isNotEmpty) {
                              utilisateurID = await AuthService().connectedID();
                              currentUser =
                                  await AuthService().getPseudo(utilisateurID);
                              groupPath = path;
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xB07888a0),
                                          borderRadius: BorderRadius.only(
                                            topRight: const Radius.circular(10),
                                            topLeft: const Radius.circular(10),
                                          )),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                children: <Widget>[
                                                  RoundedButton(
                                                      title: 'Personnaliser',
                                                      colour: Color(0xFF389490),
                                                      onPressed: () async {
                                                        setState(() {
                                                          stackIndex = 1;
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      }),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              //height: 338,
                                              child: AlertStream(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            }
                          } on SocketException catch (_) {
                            _showSnackBar(
                                'Vérifiez votre connexion internet', context);
                          }
                        },
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: MediaQuery.of(context).size.height * 0.10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(33.0),
                          color: Color(0xFF3B466B),
                          //color:Color.fromRGBO(59, 70, 150, 0.8),
                        ),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: liste,
                          shrinkWrap: false,
                        ),
                      ),
                    ],
                  ),
                ),
                //nom groupe
                Positioned(
                  bottom: 60,
                  left: MediaQuery.of(context).size.width * 0.025,
                  child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: primarycolor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey,
                            blurRadius: 3.0,
                            spreadRadius: 0.1,
                            offset: Offset(0.0, 1.0),
                          )
                        ],
                      ),
                      child: Text(
                        groupe.nom,
                        style: TextStyle(
                          color: myWhite,
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ),
                //floationg butons asma
                Positioned(
                  right: 5,
                  //MediaQuery.of(context).size.width*0.05,
                  bottom: MediaQuery.of(context).size.height * 0.15,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: FloatingActionButton(
                          heroTag: null,
                          onPressed: () async {
                            try {
                              final result =
                                  await InternetAddress.lookup('google.com');
                              var result2 =
                                  await Connectivity().checkConnectivity();
                              var b = (result2 != ConnectivityResult.none);

                              if (b &&
                                  result.isNotEmpty &&
                                  result[0].rawAddress.isNotEmpty) {
                                // show input autocomplete with selected mode
                                // then get the Prediction selected
                                Prediction p = await PlacesAutocomplete.show(
                                  context: context,
                                  apiKey: kGoogleApiKey,
                                  onError: onErrorvoyage,
                                  mode: Mode.overlay,
                                  language: "fr",
                                  components: [
                                    Component(Component.country, "DZ")
                                  ],
                                );
                                if (p != null) {
                                  PlacesDetailsResponse detail = await _places
                                      .getDetailsByPlaceId(p.placeId);

                                  double lat =
                                      detail.result.geometry.location.lat;
                                  double lng =
                                      detail.result.geometry.location.lng;

                                  PlanifierArrets()
                                      .addArretsToSubCol(path, lat, lng);
                                }
                              }
                            } on SocketException catch (_) {
                              _showSnackBar(
                                  'Vérifiez votre connexion internet', context);
                            }
                          },
                          backgroundColor: Color(0xFF389490),
                          foregroundColor: Color(0xFFFFFFFF),
                          child: Icon(
                            Icons.free_breakfast,
                            size: 20,
                          ),
                        ),
                      ),
                      Padding(
                        //asma boite reception
                        padding: EdgeInsets.all(3),
                        child: FloatingActionButton(
                          heroTag: null,
                          onPressed: () async {
                            try {
                              final result =
                                  await InternetAddress.lookup('google.com');
                              var result2 =
                                  await Connectivity().checkConnectivity();
                              var b = (result2 != ConnectivityResult.none);

                              if (b &&
                                  result.isNotEmpty &&
                                  result[0].rawAddress.isNotEmpty) {
                                utilisateurID =
                                    await AuthService().connectedID();
                                currentUser = await AuthService()
                                    .getPseudo(utilisateurID);
                                setState(() {
                                  groupPath = path;
                                  stackIndex = 2;
                                });
                              }
                            } on SocketException catch (_) {
                              _showSnackBar(
                                  'Vérifiez votre connexion internet', context);
                            }
                          },
                          backgroundColor: Color(0xFF389490),
                          foregroundColor: Color(0xFFFFFFFF),
                          child: Icon(
                            Icons.message,
                            size: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: FloatingActionButton(
                          heroTag: null,
                          onPressed: () async {
                            try {
                              final result =
                                  await InternetAddress.lookup('google.com');
                              var result2 =
                                  await Connectivity().checkConnectivity();
                              var b = (result2 != ConnectivityResult.none);

                              if (b &&
                                  result.isNotEmpty &&
                                  result[0].rawAddress.isNotEmpty) {
                                // Navigator.pushNamed(context, ListGrpPage.id);
                                Navigator.pop(context);
                              }
                            } on SocketException catch (_) {
                              _showSnackBar(
                                  'Vérifiez votre connexion internet', context);
                            }
                          },
                          backgroundColor: Color(0xFF389490),
                          foregroundColor: Color(0xFFFFFFFF),
                          child: Icon(
                            Icons.group,
                            size: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: FloatingActionButton(
                          heroTag: null,
                          onPressed: () {
                            setState(() {
                              index = 2;
                            });
                          },
                          backgroundColor: Color(0xFF389490),
                          foregroundColor: Color(0xFFFFFFFF),
                          child: Icon(
                            Icons.group_add,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //la fenetre personnaliser asma
                IndexedStack(
                  index: stackIndex,
                  children: <Widget>[
                    Container(),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            FlatButton(
                                padding: EdgeInsets.all(0),
                                child: Container(
                                  color: Color(0x99707070),
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                                onPressed: () async {
                                  try {
                                    final result = await InternetAddress.lookup(
                                        'google.com');
                                    var result2 = await Connectivity()
                                        .checkConnectivity();
                                    var b =
                                        (result2 != ConnectivityResult.none);

                                    if (b &&
                                        result.isNotEmpty &&
                                        result[0].rawAddress.isNotEmpty) {
                                      setState(() {
                                        stackIndex = 0;
                                      });
                                    }
                                  } on SocketException catch (_) {
                                    _showSnackBar(
                                        'Vérifiez votre connexion internet',
                                        context);
                                  }
                                }),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 380,
                                height: 280,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      responsiveradius(10, 1)),
                                  color: Color(0xFFd0d8e8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey,
                                      blurRadius: 3.0,
                                      spreadRadius: 1.0,
                                      offset: Offset(0.0, 2.0),
                                    )
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Personnaliser une alerte',
                                      style: TextStyle(
                                          color: Color(0xFF707070),
                                          fontSize: 18.0,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 15.0),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                responsiveradius(32.0, 1))),
                                        color: Colors.white,
                                        elevation: 5.0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            onChanged: (value) {
                                              alertePerso = value;
                                            },
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Color(0xFF707070),
                                              fontWeight: FontWeight.w600,
                                            ),
                                            decoration: InputDecoration(
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.sms_failed,
                                                  color: Color(0xFF707070),
                                                ),
                                              ),
                                              labelText: 'Contenu de l\'alerte',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        responsiveradius(
                                                            32.0, 1))),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xd03b466b),
                                                    width: 1.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        responsiveradius(
                                                            32.0, 1))),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xd03b466b),
                                                    width: 2.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        responsiveradius(
                                                            32.0, 1))),
                                              ),
                                              labelStyle: TextStyle(
                                                color: Color(0xd03b466b),
                                              ),
                                            ),
                                            maxLength: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    RoundedButton(
                                      title: 'Ok',
                                      colour: Color(0xd03b466b),
                                      onPressed: () async {
                                        try {
                                          final result =
                                              await InternetAddress.lookup(
                                                  'google.com');
                                          var result2 = await Connectivity()
                                              .checkConnectivity();
                                          var b = (result2 !=
                                              ConnectivityResult.none);

                                          if (b &&
                                              result.isNotEmpty &&
                                              result[0].rawAddress.isNotEmpty) {
                                            if (alertePerso != null) {
                                              /*final QuerySnapshot result = await Future.value(_firestore.collection('Utilisateur').where('pseudo',isEqualTo: currentUser).getDocuments()) ;
                                          List<DocumentSnapshot> fff=result.documents;
                                          DocumentSnapshot fff1=fff[0];*/
                                              _firestore
                                                  .collection('Utilisateur')
                                                  .document(utilisateurID)
                                                  .updateData({
                                                'alertLIST':
                                                    FieldValue.arrayUnion(
                                                        [alertePerso]),
                                              });
                                              alertePerso = null;
                                            }
                                            setState(() {
                                              stackIndex = 0;
                                              _controller.clear();
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                            });
                                          }
                                        } on SocketException catch (_) {
                                          _showSnackBar(
                                              'Vérifiez votre connexion internet',
                                              context);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Container(
                              color: Color(0x99707070),
                              height: double.infinity,
                              width: double.infinity,
                            ),
                            onPressed: () async {
                              try {
                                final result =
                                    await InternetAddress.lookup('google.com');
                                var result2 =
                                    await Connectivity().checkConnectivity();
                                var b = (result2 != ConnectivityResult.none);

                                if (b &&
                                    result.isNotEmpty &&
                                    result[0].rawAddress.isNotEmpty) {
                                  setState(() {
                                    stackIndex = 0;
                                  });
                                }
                              } on SocketException catch (_) {
                                _showSnackBar(
                                    'Vérifiez votre connexion internet',
                                    context);
                              }
                            }),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 150.0, horizontal: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  responsiveradius(10, 1)),
                              color: Color(0xFFd0d8e8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueGrey,
                                  blurRadius: 3.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(0.0, 2.0),
                                )
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    'Boite de recécption',
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        color: Color(0xFF3b466b),
                                        fontSize: 18.0,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child:
                                        ReceivedAlertStream(settingindex: () {
                                      setState(() {
                                        stackIndex = 0;
                                      });
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    //indexe3
                    NotifStream(ffunction: () {
                      setState(() {
                        stackIndex = 2;
                      });
                    }),
                  ],
                ),
              ],
            ),
            // the drawer, index=1
            Container(
              width: size.width,
              height: size.height,
              color: Color.fromRGBO(255, 255, 255, 0.5),
              child: Column(
                children: <Widget>[
                  Spacer(
                    flex: 1,
                  ),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () async {
                          try {
                            final result =
                                await InternetAddress.lookup('google.com');
                            var result2 =
                                await Connectivity().checkConnectivity();
                            var b = (result2 != ConnectivityResult.none);

                            if (b &&
                                result.isNotEmpty &&
                                result[0].rawAddress.isNotEmpty) {
                              // _closeDrawer(context);
                              setState(() {
                                index = 0;
                              });
                            }
                          } on SocketException catch (_) {
                            _showSnackBar(
                                'Vérifiez votre connexion internet', context);
                          }
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Center(
                    child: Container(
                      height: 450,
                      width: 280,
                      //margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: primarycolor, //Color.fromRGBO(59, 70, 107, 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Spacer(
                            flex: 1,
                          ),
                          Container(
                            height: 80,
                            // MediaQuery.of(context).size.height * 0.1 * 0.65,
                            width: 80,
                            // MediaQuery.of(context).size.height * 0.1 * 0.65,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            child: CircleAvatar(
                              backgroundColor: Color(0xFFFFFFFF),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(Userimage)),
                            ),
                          ),
                          Center(
                            child: Text(
                              Username,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  fontSize: responsivetext(15),
                                  color: Colors.white),
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                ListTile(
                                  onTap: () async {
                                    try {
                                      final result =
                                          await InternetAddress.lookup(
                                              'google.com');
                                      var result2 = await Connectivity()
                                          .checkConnectivity();
                                      var b =
                                          (result2 != ConnectivityResult.none);

                                      if (b &&
                                          result.isNotEmpty &&
                                          result[0].rawAddress.isNotEmpty) {
                                        String id =
                                            await authService.connectedID();
                                        if (id != null) {
                                          DocumentSnapshot snapshot =
                                              await authService.userRef
                                                  .document(id)
                                                  .get();

                                          if (snapshot != null) {
                                            Utilisateur utilisateur =
                                                Utilisateur.fromdocSnapshot(
                                                    snapshot);
                                            //  Navigator.pushNamed(context, Home.id);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfileScreen(
                                                            utilisateur)));
                                          }
                                        }
                                      }
                                    } on SocketException catch (_) {
                                      _showSnackBar(
                                          'Vérifiez votre connexion internet',
                                          context);
                                    }
                                  },
                                  leading: Icon(
                                    Icons.playlist_add_check,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    "Compte",
                                    //strutStyle: ,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        color: myWhite,
                                        fontSize: 15),
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, FavoritePlacesScreen.id);
                                  },
                                  leading: Icon(Icons.star, color: myWhite),
                                  title: Text(
                                    "Favoris",
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        color: myWhite,
                                        fontSize: 15),
                                  ),
                                ),
                                ListTile(
                                  onTap: () async {
                                    try {
                                      final result =
                                          await InternetAddress.lookup(
                                              'google.com');
                                      var result2 = await Connectivity()
                                          .checkConnectivity();
                                      var b =
                                          (result2 != ConnectivityResult.none);

                                      if (b &&
                                          result.isNotEmpty &&
                                          result[0].rawAddress.isNotEmpty) {
                                        String currentUser =
                                            await AuthService().connectedID();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FriendsListScreen(
                                                        currentUser)));
                                      }
                                    } on SocketException catch (_) {
                                      _showSnackBar(
                                          'Vérifiez votre connexion internet',
                                          context);
                                    }
                                  },
                                  leading: Icon(
                                    Icons.group,
                                    color: myWhite,
                                  ),
                                  title: Text(
                                    "Liste d'amis",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        color: myWhite,
                                        fontSize: 15),
                                    //strutStyle: ,
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(context, AidePage.id);
                                  },
                                  leading: Icon(
                                    Icons.build,
                                    color: myWhite,
                                  ),
                                  title: Text(
                                    "Aide",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                      color: myWhite,
                                      fontSize: responsivetext(15),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    Provider.of<AuthService>(context,
                                            listen: false)
                                        .positionStream
                                        ?.cancel();
                                    Provider.of<UpdateMarkers>(context,
                                            listen: false)
                                        .stream
                                        ?.cancel();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignoutWait()));
                                  },
                                  leading: Icon(
                                    Icons.directions_run,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    "Déconnecter",
                                    //strutStyle: ,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        color: myWhite,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 5,
                  ),
                ],
              ),
            ),
            //index = 2 : choix de groupe
            Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      //  _visible = !_visible;
                      index = 0;
                    });
                  },
                  child: Container(
                    height: size.height,
                    width: size.width,
                    color: Color.fromRGBO(255, 255, 255, 0.2),
                  ),
                ),
                Container(
                    width: size.width,
                    height: size.height,
                    child: Center(
                      child: Container(
                        height: 370,
                        width: 266,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(responsiveradius(10, 1)),
                            color: Color.fromRGBO(59, 70, 107, 0.5)),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Spacer(
                                flex: 1,
                              ),
                              Text("Créer un groupe ",
                                  style: TextStyle(
                                    fontSize: responsivetext(17),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  )),
                              Spacer(
                                flex: 1,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    index = 0;
                                  });
                                  Navigator.pushNamed(context, NvVoyagePage.id);
                                },
                                child: Bouton(
                                  icon: Icon(
                                    Icons.directions_bus,
                                    color: Color(0xff707070),
                                    size: responsivewidth(75),
                                  ),
                                  contenu: Text(
                                    "de voyage",
                                    style: TextStyle(
                                        fontSize: responsivetext(14.0),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Montserrat',
                                        color: Color(0xff707070)),
                                  ),
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    index = 0;
                                  });
                                  Navigator.pushNamed(
                                      context, NvLongTermePage.id);
                                },
                                child: Bouton(
                                  icon: Icon(
                                    Icons.people,
                                    color: Color(0xff707070),
                                    size: responsivewidth(75),
                                  ),
                                  contenu: Text(
                                    "a long terme",
                                    style: TextStyle(
                                        fontSize: responsivetext(14.0),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Montserrat',
                                        color: Color(0xff707070)),
                                  ),
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            ),
            //index =3 : barre d'info
            Stack(
              children: <Widget>[
                Container(
                    height: size.height,
                    width: size.width,
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          final result =
                              await InternetAddress.lookup('google.com');
                          var result2 =
                              await Connectivity().checkConnectivity();
                          var b = (result2 != ConnectivityResult.none);

                          if (b &&
                              result.isNotEmpty &&
                              result[0].rawAddress.isNotEmpty) {
                            GeoPoint point;
                            CameraUpdate cameraUpdate;
                            String val = await authService.connectedID();
                            await Firestore.instance
                                .document(path)
                                .collection('members')
                                .document(val)
                                .get()
                                .then((DocumentSnapshot ds) {
                              point = ds.data['position']['geopoint'];
                            });
                            LatLng latlng =
                                new LatLng(point.latitude, point.longitude);
                            cameraUpdate =
                                CameraUpdate.newLatLngZoom(latlng, 13);
                            Provider.of<controllermap>(context, listen: false)
                                .mapController
                                .animateCamera(cameraUpdate);
                            setState(() {
                              // pour dezoumer de cette personne
                              // et remettre la cam sur l'utilisateur courrant
                              index = 0;
                            });
                          }
                        } on SocketException catch (_) {
                          _showSnackBar(
                              'Vérifiez votre connexion internet', context);
                        }
                      },
                    )),
                Positioned(
                  bottom: 4,
                  left: MediaQuery.of(context).size.width * 0.025,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(33.0),
                      color: Color(0xFF3B466B),
                      //color:Color.fromRGBO(59, 70, 150, 0.8),
                    ),
                    child: Row(
                      children: <Widget>[
                        Spacer(
                          flex: 1,
                        ),
                        Padding(
                          padding: EdgeInsets.all(7),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.height *
                                    0.1 *
                                    0.65,
                                width: MediaQuery.of(context).size.height *
                                    0.1 *
                                    0.65,
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                child: CircleAvatar(
                                  backgroundColor: Color(0xFFFFFFFF),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child:
                                          Image.network(membreinfo['image'])),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    membreinfo['pseudo'],
                                    style: TextStyle(
                                      fontFamily: 'MontSerrat',
                                      fontSize: responsivetext(10),
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //distance restante restant
                        Spacer(
                          flex: 1,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            height: 40,
                            width: 40,
                            child: membreinfo['vitesse'],
                          ),
                        ),
                        Spacer(flex: 1),
                        //temps restant
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            height: 40,
                            width: 40,
                            child: membreinfo['temps'],
                          ),
                        ),
                        //niveau de batterie
                        Spacer(flex: 1),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            height: 40,
                            width: 40,
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.battery_std,
                                  color: Color(0xFFFFFFFF),
                                  semanticLabel: '30%',
                                  textDirection: TextDirection.rtl,
                                ),
                                membreinfo['batterie'],
                              ],
                            ),
                          ),
                        ),
                        Spacer(flex: 1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
//index= 4 msg fermeture:
            Center(
                child: Container(
                    width: responsivewidth(300),
                    height: responsiveheight(150),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(responsiveradius(10, 1)),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: responsivewidth(20),
                              vertical: responsivewidth(20)),
                          child: Text(
                              'Tous les membres sont arrivés à destination. Ce voyage est terminé.',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: responsivetext(16),
                                fontWeight: FontWeight.w600,
                                color: Color(0xff707070),
                              )),
                        ),
                        Spacer(flex: 1),
                        Center(
                          child: MaterialButton(
                            child: Text('OK',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: responsivetext(16),
                                  fontWeight: FontWeight.w700,
                                  color: secondarycolor,
                                )),
                            onPressed: () async {
                              setState(() {
                                _loading = true;
                              });
                              DocumentSnapshot doc =
                                  await Firestore.instance.document(path).get();
                              if (doc.exists) {
                                await data.fermergroupe(path, groupe.nom);
                              }
                              setState(() {
                                _loading = false;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    )))
          ]),
        ],
      ),
    );
  }
}

class MapLongTermePage extends StatefulWidget {
  LongTerme groupe;
  String path;
  List<String> imagesUrl;
  MapLongTermePage(this.groupe, this.path, this.imagesUrl);

  @override
  _MapLongTermePageState createState() =>
      _MapLongTermePageState(groupe, path, imagesUrl);
}

class _MapLongTermePageState extends State<MapLongTermePage> {
  LongTerme groupe;
  String path;
  bool _visible = true;
  Color c1 = const Color.fromRGBO(0, 0, 60, 0.8);
  Color c2 = const Color(0xFF3B466B);
  Color myWhite = const Color(0xFFFFFFFF);
  int index;
  List<String> imagesUrl;
  _MapLongTermePageState(this.groupe, this.path, this.imagesUrl);

  @override
  void initState() {
    Userimage =
        'https://firebasestorage.googleapis.com/v0/b/winek-70176.appspot.com/o/photos%2Flogo.png?alt=media&token=3103246d-243e-42ec-9368-cab992206d49';
    Username = '';
    index = 0;
  }

  _showSnackBarlongterm(String value, BuildContext context) {
    longtermeScaffoldKey.currentState.showSnackBar(SnackBar(
      content: new Text(
        value,
        style: TextStyle(
            color: Colors.white,
            fontSize: responsivetext(14.0),
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600),
      ),
      duration: new Duration(seconds: 2),

      behavior: SnackBarBehavior.floating,
      //backgroundColor: Colors.green,
      action: new SnackBarAction(
          label: 'Ok',
          onPressed: () {
            print('press Ok on SnackBar');
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> liste = new List();
    //  var it = groupe.membres.iterator;
    for (int i = 0; i < groupe.membres.length; i++) {
      liste.add(
        Padding(
          padding: EdgeInsets.all(7),
          child: InkWell(
//onPressed: null,
//minWidth: 85,
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.1 * 0.65,
                  width: MediaQuery.of(context).size.height * 0.1 * 0.65,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: CircleAvatar(
                    backgroundColor: Color(0xFFFFFFFF),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: GestureDetector(
                            onTap: () async {
                              GeoPoint point;
                              CameraUpdate cameraUpdate;
                              await Firestore.instance
                                  .document(path)
                                  .collection('members')
                                  .document(groupe.membres[i]['id'])
                                  .get()
                                  .then((DocumentSnapshot ds) {
                                point = ds.data['position']['geopoint'];
                              });
                              LatLng latlng =
                                  new LatLng(point.latitude, point.longitude);
                              cameraUpdate =
                                  CameraUpdate.newLatLngZoom(latlng, 13);
                              Provider.of<controllermap>(context, listen: false)
                                  .mapController
                                  .animateCamera(cameraUpdate);
                              setState(() {
                                index = 3;
                              });
                            },
                            child: Image.network(imagesUrl[i]))),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      groupe.membres[i]['pseudo'],
                      style: TextStyle(
                        fontFamily: 'MontSerrat',
                        fontSize: responsivetext(10),
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      key: longtermeScaffoldKey,
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            mapToolbarEnabled: true,
            onMapCreated: Provider.of<controllermap>(context, listen: false)
                ._onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(36.7525000, 3.0419700),
              zoom: 11.0,
            ),
            markers: Set<Marker>.of(
                Provider.of<UpdateMarkers>(context).markers.values),
          ),
          IndexedStack(index: index, children: <Widget>[
            //index = 0 :
            Stack(
              children: <Widget>[
                Positioned(
                  left: size.width * 0.075,
                  top: size.height * 0.04,
                  // child: AnimatedOpacity(
                  // opacity: _visible ? 1.0 : 0.0,
                  //duration: Duration(milliseconds: 500),
                  child: Container(
                      height: size.height * 0.07,
                      width: size.width * 0.85,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(responsiveradius(40.0, 1)),
                          color: Colors.white),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.menu,
                                color: Color(0xFF3B466B),
                              ),
                              onPressed: () async {
                                try {
                                  final result = await InternetAddress.lookup(
                                      'google.com');
                                  var result2 =
                                      await Connectivity().checkConnectivity();
                                  var b = (result2 != ConnectivityResult.none);

                                  if (b &&
                                      result.isNotEmpty &&
                                      result[0].rawAddress.isNotEmpty) {
                                    String id = await authService.connectedID();
                                    String pseudo = await Firestore.instance
                                        .collection('Utilisateur')
                                        .document(id)
                                        .get()
                                        .then((doc) {
                                      return doc.data['pseudo'];
                                    });
                                    String image = await Firestore.instance
                                        .collection('Utilisateur')
                                        .document(id)
                                        .get()
                                        .then((doc) {
                                      return doc.data['photo'];
                                    });
                                    // _openDrawer(context);
                                    setState(() {
                                      Username = pseudo;
                                      Userimage = image;
                                      index = 1;
                                      // _visible = !_visible;
                                    });
                                  }
                                } on SocketException catch (_) {
                                  _showSnackBarlongterm(
                                      'Vérifiez votre connexion internet',
                                      context);
                                }
                              },
                              iconSize: 30.0),
                          Spacer(
                            flex: 1,
                          ),
                          Center(
                            child: Text(
                              'Recherche',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat',
                                fontSize: responsivetext(15),
                                color: Color(0xff707070),
                              ),
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Color(0xFF3B466B),
                              ),
                              onPressed: () async {
                                try {
                                  final result = await InternetAddress.lookup(
                                      'google.com');
                                  var result2 =
                                      await Connectivity().checkConnectivity();
                                  var b = (result2 != ConnectivityResult.none);

                                  if (b &&
                                      result.isNotEmpty &&
                                      result[0].rawAddress.isNotEmpty) {
                                    Prediction p =
                                        await PlacesAutocomplete.show(
                                      context: context,
                                      apiKey: kGoogleApiKey,
                                      onError: onErrorlongterme,
                                      mode: Mode.overlay,
                                      language: "fr",
                                      components: [
                                        Component(Component.country, "DZ")
                                      ],
                                    );

                                    Provider.of<controllermap>(context,
                                            listen: false)
                                        .displayPredictionRecherche(p);
                                  }
                                } on SocketException catch (_) {
                                  _showSnackBarlongterm(
                                      'Vérifiez votre connexion internet',
                                      context);
                                }
                              },
                              iconSize: responsivewidth(30.0)),
                        ],
                      )),
                ),
                Positioned(
                  bottom: responsiveheight(5),
                  left: MediaQuery.of(context).size.width * 0.025,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(33.0),
                      color: Color(0xFF3B466B),
                      //color:Color.fromRGBO(59, 70, 150, 0.8),
                    ),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: liste,
                      shrinkWrap: false,
                    ),
                  ),
                ),
                //nom groupe
                Positioned(
                  bottom: responsiveheight(65),
                  left: MediaQuery.of(context).size.width * 0.025,
                  child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: primarycolor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey,
                            blurRadius: 3.0,
                            spreadRadius: 0.1,
                            offset: Offset(0.0, 1.0),
                          )
                        ],
                      ),
                      child: Text(
                        groupe.nom,
                        style: TextStyle(
                          color: myWhite,
                          fontSize: responsivetext(12),
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ),
                //floationg butons
                Positioned(
                  right: responsivewidth(5),
                  //MediaQuery.of(context).size.width*0.05,
                  bottom: MediaQuery.of(context).size.height * 0.15,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: responsivewidth(3),
                            vertical: responsiveheight(3)),
                        child: FloatingActionButton(
                          heroTag: null,
                          onPressed: () async {
                            try {
                              final result =
                                  await InternetAddress.lookup('google.com');
                              var result2 =
                                  await Connectivity().checkConnectivity();
                              var b = (result2 != ConnectivityResult.none);

                              if (b &&
                                  result.isNotEmpty &&
                                  result[0].rawAddress.isNotEmpty) {
                                Navigator.pop(context);
                                //  Navigator.pushNamed(context, ListGrpPage.id);
                              }
                            } on SocketException catch (_) {
                              _showSnackBarlongterm(
                                  'Vérifiez votre connexion internet', context);
                            }
                          },
                          backgroundColor: Color(0xFF389490),
                          foregroundColor: Color(0xFFFFFFFF),
                          child: Icon(
                            Icons.group,
                            size: 30,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: FloatingActionButton(
                          heroTag: null,
                          onPressed: () async {
                            try {
                              final result =
                                  await InternetAddress.lookup('google.com');
                              var result2 =
                                  await Connectivity().checkConnectivity();
                              var b = (result2 != ConnectivityResult.none);

                              if (b &&
                                  result.isNotEmpty &&
                                  result[0].rawAddress.isNotEmpty) {
                                setState(() {
                                  index = 2;
                                });
                              }
                            } on SocketException catch (_) {
                              _showSnackBarlongterm(
                                  'Vérifiez votre connexion internet', context);
                            }
                          },
                          backgroundColor: Color(0xFF389490),
                          foregroundColor: Color(0xFFFFFFFF),
                          child: Icon(
                            Icons.group_add,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // the drawer, index=1
            Container(
              width: size.width,
              height: size.height,
              color: Color.fromRGBO(255, 255, 255, 0.5),
              child: Column(
                children: <Widget>[
                  Spacer(
                    flex: 1,
                  ),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () async {
                          try {
                            final result =
                                await InternetAddress.lookup('google.com');
                            var result2 =
                                await Connectivity().checkConnectivity();
                            var b = (result2 != ConnectivityResult.none);

                            if (b &&
                                result.isNotEmpty &&
                                result[0].rawAddress.isNotEmpty) {
                              // _closeDrawer(context);
                              setState(() {
                                index = 0;
                              });
                            }
                          } on SocketException catch (_) {
                            _showSnackBarlongterm(
                                'Vérifiez votre connexion internet', context);
                          }
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Center(
                    child: Container(
                      height: 450,
                      width: 280,
                      //margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: primarycolor, //Color.fromRGBO(59, 70, 107, 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Spacer(
                            flex: 1,
                          ),
                          Container(
                            height: 80,
                            // MediaQuery.of(context).size.height * 0.1 * 0.65,
                            width: 80,
                            // MediaQuery.of(context).size.height * 0.1 * 0.65,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            child: CircleAvatar(
                              backgroundColor: Color(0xFFFFFFFF),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(Userimage)),
                            ),
                          ),
                          Center(
                            child: Text(
                              Username,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  fontSize: responsivetext(15),
                                  color: Colors.white),
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                ListTile(
                                  onTap: () async {
                                    try {
                                      final result =
                                          await InternetAddress.lookup(
                                              'google.com');
                                      var result2 = await Connectivity()
                                          .checkConnectivity();
                                      var b =
                                          (result2 != ConnectivityResult.none);

                                      if (b &&
                                          result.isNotEmpty &&
                                          result[0].rawAddress.isNotEmpty) {
                                        String id =
                                            await authService.connectedID();
                                        if (id != null) {
                                          DocumentSnapshot snapshot =
                                              await authService.userRef
                                                  .document(id)
                                                  .get();

                                          if (snapshot != null) {
                                            Utilisateur utilisateur =
                                                Utilisateur.fromdocSnapshot(
                                                    snapshot);
                                            //  Navigator.pushNamed(context, Home.id);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfileScreen(
                                                            utilisateur)));
                                          }
                                        }
                                      }
                                    } on SocketException catch (_) {
                                      _showSnackBarlongterm(
                                          'Vérifiez votre connexion internet',
                                          context);
                                    }
                                  },
                                  leading: Icon(
                                    Icons.playlist_add_check,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    "Compte",
                                    //strutStyle: ,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        color: myWhite,
                                        fontSize: 15),
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, FavoritePlacesScreen.id);
                                  },
                                  leading: Icon(Icons.star, color: myWhite),
                                  title: Text(
                                    "Favoris",
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        color: myWhite,
                                        fontSize: 15),
                                  ),
                                ),
                                ListTile(
                                  onTap: () async {
                                    String currentUser =
                                        await AuthService().connectedID();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FriendsListScreen(
                                                    currentUser)));
                                  },
                                  leading: Icon(
                                    Icons.group,
                                    color: myWhite,
                                  ),
                                  title: Text(
                                    "Liste d'amis",
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        color: myWhite,
                                        fontSize: 15),
                                    //strutStyle: ,
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(context, AidePage.id);
                                  },
                                  leading: Icon(
                                    Icons.build,
                                    color: myWhite,
                                  ),
                                  title: Text(
                                    "Aide",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                      color: myWhite,
                                      fontSize: responsivetext(15),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    Provider.of<AuthService>(context,
                                            listen: false)
                                        .positionStream
                                        ?.cancel();
                                    Provider.of<UpdateMarkers>(context,
                                            listen: false)
                                        .stream
                                        ?.cancel();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignoutWait()));
                                  },
                                  leading: Icon(
                                    Icons.directions_run,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    "Déconnecter",
                                    //strutStyle: ,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        color: myWhite,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 5,
                  ),
                ],
              ),
            ),
            //index = 2 : choix de groupe
            GestureDetector(
              onTap: () {
                setState(() {
                  _visible = !_visible;
                  index = 0;
                });
              },
              child: Container(
                  width: size.width,
                  height: size.height,
                  child: Center(
                    child: Container(
                      height: 370,
                      width: 266,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(responsiveradius(10, 1)),
                          color: Color.fromRGBO(59, 70, 107, 0.5)),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Spacer(
                              flex: 1,
                            ),
                            Text("Créer un groupe ",
                                style: TextStyle(
                                  fontSize: responsivetext(17),
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                )),
                            Spacer(
                              flex: 1,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  index = 0;
                                });

                                Navigator.pushNamed(context, NvVoyagePage.id);
                              },
                              child: Bouton(
                                icon: Icon(
                                  Icons.directions_bus,
                                  color: Color(0xff707070),
                                  size: responsivewidth(75),
                                ),
                                contenu: Text(
                                  "de voyage",
                                  style: TextStyle(
                                      fontSize: responsivetext(14.0),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Montserrat',
                                      color: Color(0xff707070)),
                                ),
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  index = 0;
                                });
                                Navigator.pushNamed(
                                    context, NvLongTermePage.id);
                              },
                              child: Bouton(
                                icon: Icon(
                                  Icons.people,
                                  color: Color(0xff707070),
                                  size: responsivewidth(75),
                                ),
                                contenu: Text(
                                  "a long terme",
                                  style: TextStyle(
                                      fontSize: responsivetext(14.0),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Montserrat',
                                      color: Color(0xff707070)),
                                ),
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () async {
                      GeoPoint point;
                      CameraUpdate cameraUpdate;
                      String val = await authService.connectedID();
                      await Firestore.instance
                          .document(path)
                          .collection('members')
                          .document(val)
                          .get()
                          .then((DocumentSnapshot ds) {
                        point = ds.data['position']['geopoint'];
                      });
                      LatLng latlng =
                          new LatLng(point.latitude, point.longitude);
                      cameraUpdate = CameraUpdate.newLatLngZoom(latlng, 13);
                      Provider.of<controllermap>(context, listen: false)
                          .mapController
                          .animateCamera(cameraUpdate);
                      setState(() {
                        index = 0;
                      });
                    },
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Positioned(
                      left: size.width * 0.075,
                      top: size.height * 0.04,
// child: AnimatedOpacity(
// opacity: _visible ? 1.0 : 0.0,
//duration: Duration(milliseconds: 500),
                      child: Container(
                          height: size.height * 0.07,
                          width: size.width * 0.85,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              color: Colors.white),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.menu,
                                    color: Color(0xFF3B466B),
                                  ),
                                  onPressed: () async {
                                    String id = await authService.connectedID();
                                    String pseudo = await Firestore.instance
                                        .collection('Utilisateur')
                                        .document(id)
                                        .get()
                                        .then((doc) {
                                      return doc.data['pseudo'];
                                    });
                                    String image = await Firestore.instance
                                        .collection('Utilisateur')
                                        .document(id)
                                        .get()
                                        .then((doc) {
                                      return doc.data['photo'];
                                    });
// _openDrawer(context);
                                    setState(() {
                                      Username = pseudo;
                                      Userimage = image;
                                      index = 1;
// _visible = !_visible;
                                    });
                                  },
                                  iconSize: 30.0),
                              Spacer(
                                flex: 1,
                              ),
                              Center(
                                child: Text(
                                  'Recherche',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Montserrat',
                                    fontSize: responsivetext(15),
                                    color: Color(0xff707070),
                                  ),
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: Color(0xFF3B466B),
                                  ),
                                  onPressed: () async {
// show input autocomplete with selected mode
// then get the Prediction selected
                                    Prediction p =
                                        await PlacesAutocomplete.show(
                                      context: context,
                                      apiKey: kGoogleApiKey,
                                      onError: onErrorlongterme,
                                      mode: Mode.overlay,
                                      language: "fr",
                                      components: [
                                        Component(Component.country, "DZ")
                                      ],
                                    );

                                    Provider.of<controllermap>(context,
                                            listen: false)
                                        .displayPredictionRecherche(p);
                                  },
                                  iconSize: 30.0),
                            ],
                          )),
                    ),
//liste of members
                    Positioned(
                      bottom: 5,
                      left: MediaQuery.of(context).size.width * 0.025,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: MediaQuery.of(context).size.height * 0.10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(33.0),
                          color: Color(0xFF3B466B),
//color:Color.fromRGBO(59, 70, 150, 0.8),
                        ),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: liste,
                          shrinkWrap: false,
                        ),
                      ),
                    ),
//nom groupe
                    Positioned(
                      bottom: 65,
                      left: MediaQuery.of(context).size.width * 0.025,
                      child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: primarycolor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey,
                                blurRadius: 3.0,
                                spreadRadius: 0.1,
                                offset: Offset(0.0, 1.0),
                              )
                            ],
                          ),
                          child: Text(
                            groupe.nom,
                            style: TextStyle(
                              color: myWhite,
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ),
//floationg butons
                    Positioned(
                      right: 5,
//MediaQuery.of(context).size.width*0.05,
                      bottom: MediaQuery.of(context).size.height * 0.15,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(3),
                            child: FloatingActionButton(
                              heroTag: null,
                              onPressed: () {
                                Navigator.pop(context);
                                //   Navigator.pushNamed(context, ListGrpPage.id);
                              },
                              backgroundColor: Color(0xFF389490),
                              foregroundColor: Color(0xFFFFFFFF),
                              child: Icon(
                                Icons.group,
                                size: 30,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(3),
                            child: FloatingActionButton(
                              heroTag: null,
                              onPressed: () {
                                setState(() {
                                  index = 2;
                                });
                              },
                              backgroundColor: Color(0xFF389490),
                              foregroundColor: Color(0xFFFFFFFF),
                              child: Icon(
                                Icons.group_add,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          ]),
        ],
      ),
    );
  }
}

class ChoixGrp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 370,
        width: 266,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(responsiveradius(10, 1)),
            color: Color.fromRGBO(59, 70, 107, 0.5)),
        child: Center(
          child: Column(
            children: <Widget>[
              Spacer(
                flex: 1,
              ),
              Text("Créer un groupe ",
                  style: TextStyle(
                    fontSize: responsivetext(17),
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  )),
              Spacer(
                flex: 1,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, NvVoyagePage.id);
                },
                child: Bouton(
                  icon: Icon(
                    Icons.directions_bus,
                    color: Color(0xff707070),
                    size: responsivewidth(75),
                  ),
                  contenu: Text(
                    "de voyage",
                    style: TextStyle(
                        fontSize: responsivetext(14.0),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        color: Color(0xff707070)),
                  ),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, NvLongTermePage.id);
                },
                child: Bouton(
                  icon: Icon(
                    Icons.people,
                    color: Color(0xff707070),
                    size: responsivewidth(75),
                  ),
                  contenu: Text(
                    "a long terme",
                    style: TextStyle(
                        fontSize: responsivetext(14.0),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        color: Color(0xff707070)),
                  ),
                ),
              ),
              Spacer(
                flex: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Bouton extends StatelessWidget {
  final Icon icon;
  final Text contenu;

  Bouton({@required this.icon, @required this.contenu});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: responsiveheight(106),
        width: responsivewidth(113),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(responsiveradius(10, 1)),
        ),
        child: Column(
          children: <Widget>[
            Spacer(
              flex: 1,
            ),
            icon,
            contenu,
            Spacer(
              flex: 1,
            )
          ],
        ));
  }
}

//asma la fin
class AlertBubble extends StatelessWidget {
  final icon;
  final text;
  final bool isReceived;

  AlertBubble({
    @required this.icon,
    @required this.text,
    @required this.isReceived,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () async {
        if (isReceived) {
        } else {
          //todo: je dis a tout le groupe qu'on vient d'envoyer une alerte ici
          try {
            final result = await InternetAddress.lookup('google.com');
            var result2 = await Connectivity().checkConnectivity();
            var b = (result2 != ConnectivityResult.none);

            if (b && result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              bool isLocationEnabled =
                  await Geolocator().isLocationServiceEnabled();
              if (isLocationEnabled) {
                //TODO: je change le just received

                Position position = await Geolocator().getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.medium);
                Geoflutterfire geo = Geoflutterfire();
                GeoFirePoint geoP = geo.point(
                    latitude: position.latitude, longitude: position.longitude);

                if (text != null &&
                    icon != null &&
                    currentUser != null &&
                    geoP != null) {
                  _firestore
                      .document(groupPath)
                      .collection('receivedAlerts')
                      .add({
                    'content': text,
                    'icon': icon.toString(),
                    'sender': currentUser,
                    'envoyeLe': DateTime.now().toUtc(),
                    'position': geoP.data,
                  });
                }

                var vvv = await _firestore.document(groupPath).get();
                bool tr = vvv.data['justReceivedAlert'];
                _firestore.document(groupPath).updateData({
                  'justReceivedAlert': !tr,
                });

                voyageScaffoldKey.currentState.showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Row(
                    children: <Widget>[
                      Text(
                        'Alerte envoyée !',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: responsivetext(14.0),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Icon(
                        Icons.check,
                        color: Color(0xFF3b466b),
                      )
                    ],
                  ),
                ));
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                voyageScaffoldKey.currentState.showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Row(
                    children: <Widget>[
                      Text(
                        'Veuillez activer votre GPS',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: responsivetext(14.0),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Icon(
                        Icons.location_off,
                        color: Colors.yellow,
                      )
                    ],
                  ),
                ));
              }
            }
          } on SocketException catch (_) {
            Navigator.pop(context);
            voyageScaffoldKey.currentState.showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Row(
                children: <Widget>[
                  Text(
                    'Vérifiez votre connexion internet',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: responsivetext(14.0),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Icon(
                    Icons.signal_wifi_off,
                    color: Colors.yellow,
                  )
                ],
              ),
            ));
          }
        }
      },
      padding: const EdgeInsets.all(0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsiveradius(32.0, 1))),
        margin: EdgeInsets.symmetric(
            vertical: responsiveheight(5.0), horizontal: responsivewidth(20.0)),
        color: Colors.white,
        elevation: 5.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: responsivewidth(11.0),
                  vertical: responsiveheight(11)),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Image(
                    image: AssetImage(
                      'images/circle.png',
                    ),
                    width: responsivewidth(52.0),
                  ),
                  Icon(
                    icon,
                    color: Color(0xFF707070),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: responsiveheight(25),
                top: responsiveheight(25),
                left: responsivewidth(8),
              ),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: responsivetext(16),
                    color: Color(0xFF707070),
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlertStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> alertList = [];
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Utilisateur').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xFF707070),
            ),
          );
        }

        final alerts = snapshot.data.documents;
        for (var alert in alerts) {
          var id = alert.documentID;
          if (utilisateurID == id) {
            final List alertText = List.from(alert.data['alertLIST']);
            for (int i = 0; i < alertText.length; i++) {
              int llist = alertList.length;
              if (llist < (alertText.length)) {
                var alertBubble = AlertBubble(
                  text: alertText[i],
                  icon: Icons.sms_failed,
                  isReceived: false,
                );
                alertList.add(alertBubble);
              }
            }
          }
        }
        return SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              AlertBubble(
                text: 'Accident',
                icon: Icons.directions_car,
                isReceived: false,
              ),
              AlertBubble(
                text: 'Arrêt',
                icon: Icons.subway,
                isReceived: false,
              ),
              AlertBubble(
                text: 'Arrivé à destination',
                icon: Icons.pin_drop,
                isReceived: false,
              ),
              AlertBubble(
                text: 'Embouteillage',
                icon: Icons.traffic,
                isReceived: false,
              ),
              AlertBubble(
                text: 'Réduction de vitesse',
                icon: Icons.av_timer,
                isReceived: false,
              ),
              AlertBubble(
                text: 'Route barrée',
                icon: Icons.block,
                isReceived: false,
              ),
              AlertBubble(
                text: 'Station-services',
                icon: Icons.local_gas_station,
                isReceived: false,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6, top: 16),
                child: Text(
                  'Vos alertes',
                  style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: responsivetext(15.0),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: alertList.length,
                itemBuilder: (context, int index) {
                  return Dismissible(
                    key: Key(index.toString()),
                    onDismissed: (direction) {
                      AlertBubble alal = alertList[index];
                      _firestore
                          .collection('Utilisateur')
                          .document(utilisateurID)
                          .updateData({
                        'alertLIST': FieldValue.arrayRemove([alal.text]),
                      });

                      alertList.removeAt(index); //iciiiiii
                      voyageScaffoldKey.currentState.showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Row(
                          children: <Widget>[
                            Text(
                              'Alerte supprimée !',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsivetext(14.0),
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Icon(
                              Icons.check,
                              color: Color(0xFF3b466b),
                            )
                          ],
                        ),
                      ));
                      Navigator.pop(context);
                    },
                    background: Container(
                      color: Color(0xB0FF5252),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: responsivewidth(15.0)),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: responsivewidth(15.0)),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: alertList[index],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class AlertScreen extends StatefulWidget {
  @override
  _AlertScreenState createState() => _AlertScreenState(() {});
}

class _AlertScreenState extends State<AlertScreen> {
  final Function onTouched;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  _AlertScreenState(this.onTouched);
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

    onTouched();
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
      'Vous avez reçu une nouvelle alerte',
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

IconData createIcon(String s) {
  switch (s) {
    case 'IconData(U+0E531)':
      {
        return Icons.directions_car;
      }
      break;
    case 'IconData(U+0E546)':
      {
        return Icons.local_gas_station;
      }
      break;
    case 'IconData(U+0E14B)':
      {
        return Icons.block;
      }
      break;
    case 'IconData(U+0E55E)':
      {
        return Icons.pin_drop;
      }
      break;
    case 'IconData(U+0E565)':
      {
        return Icons.traffic;
      }
      break;
    case 'IconData(U+0E01B)':
      {
        return Icons.av_timer;
      }
      break;
    case 'IconData(U+0E56F)':
      {
        return Icons.subway;
      }
      break;
    case 'IconData(U+0E626)':
      {
        return Icons.sms_failed;
      }
      break;
  }
}

String createIconPicture(String s) {
  switch (s) {
    case 'IconData(U+0E531)':
      {
        return 'https://firebasestorage.googleapis.com/v0/b/winek-70176.appspot.com/o/alertes_png%2FIconData(U%2B0E531).png?alt=media&token=bdc7568f-a775-4520-b938-fab05c0e2a4c';
      }
      break;
    case 'IconData(U+0E546)':
      {
        return 'https://firebasestorage.googleapis.com/v0/b/winek-70176.appspot.com/o/alertes_png%2FIconData(U%2B0E546).png?alt=media&token=1c367f23-d05e-4370-b92a-852b104e533f';
      }
      break;
    case 'IconData(U+0E14B)':
      {
        return 'https://firebasestorage.googleapis.com/v0/b/winek-70176.appspot.com/o/alertes_png%2FIconData(U%2B0E14B).png?alt=media&token=6fe13f3a-19b2-4409-abe6-00c6e3acb2fc';
      }
      break;
    case 'IconData(U+0E55E)':
      {
        return 'https://firebasestorage.googleapis.com/v0/b/winek-70176.appspot.com/o/alertes_png%2FIconData(U%2B0E55E).png?alt=media&token=e5e9b5e7-9953-4383-9bad-46dffaa058d5';
      }
      break;
    case 'IconData(U+0E565)':
      {
        return 'https://firebasestorage.googleapis.com/v0/b/winek-70176.appspot.com/o/alertes_png%2FIconData(U%2B0E565).png?alt=media&token=8dd622f7-3a37-48d8-a1ff-8fc0dbe4e318';
      }
      break;
    case 'IconData(U+0E01B)':
      {
        return 'https://firebasestorage.googleapis.com/v0/b/winek-70176.appspot.com/o/alertes_png%2FIconData(U%2B0E01B).png?alt=media&token=650c3f9c-c64c-44d6-aa88-a3e091290dd9';
      }
      break;
    case 'IconData(U+0E56F)':
      {
        return 'https://firebasestorage.googleapis.com/v0/b/winek-70176.appspot.com/o/alertes_png%2FIconData(U%2B0E56F).png?alt=media&token=99f954c8-dede-4462-b7b0-d75649bb4aab';
      }
      break;
    case 'IconData(U+0E626)':
      {
        return 'https://firebasestorage.googleapis.com/v0/b/winek-70176.appspot.com/o/alertes_png%2FIconData(U%2B0E626).png?alt=media&token=1f27e891-712c-49ae-9250-0a017287559f';
      }
      break;
  }
}

class ReceivedAlertBubble extends StatelessWidget {
  String sender;
  AlertBubbleBox alert;
  DateTime date;
  GeoPoint geoPoint;
  Function settingindex = () {};

  ReceivedAlertBubble(
      {String sender,
      AlertBubbleBox alert,
      Timestamp date,
      GeoPoint geoPoint,
      Function settingindex}) {
    this.sender = sender;
    this.date = date.toDate();
    this.alert = alert;
    this.geoPoint = geoPoint;
    this.settingindex = settingindex;
  }

  Future<BitmapDescriptor> createMarkerIc() async {
    return await UpdateMarkers2().getMarkerIcon(
        createIconPicture(alert.icon.toString()), Size(150, 150));
  }

  _showSnackBar(String value, BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(SnackBar(
      content: new Text(
        value,
        style: TextStyle(
            color: Colors.white,
            fontSize: responsivetext(14.0),
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600),
      ),
      duration: new Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      //backgroundColor: Colors.green,
      action: new SnackBarAction(
          label: 'Ok',
          onPressed: () {
            print('press Ok on SnackBar');
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlatButton(
        onPressed: () async {
          try {
            final result = await InternetAddress.lookup('google.com');
            var result2 = await Connectivity().checkConnectivity();
            var b = (result2 != ConnectivityResult.none);

            if (b && result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              MarkerId markerId = MarkerId(
                  geoPoint.latitude.toString() + geoPoint.longitude.toString());
              Provider.of<UpdateMarkers>(
                context,
              ).markers.remove(markerId);

              Marker _marker = Marker(
                markerId: markerId,
                position: LatLng(geoPoint.latitude, geoPoint.longitude),
                infoWindow: InfoWindow(title: sender, snippet: alert.text),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
//            icon: await UpdateMarkers2().getMarkerIcon(createIconPicture(alert.icon.toString()), Size(150,150)),
                icon: await createMarkerIc(),
              );
              Provider.of<UpdateMarkers>(
                context,
              ).markers[markerId] = _marker;

              CameraUpdate cameraUpdate;
              cameraUpdate = CameraUpdate.newLatLngZoom(
                  LatLng(geoPoint.latitude, geoPoint.longitude), 10);
              Provider.of<controllermap>(context, listen: false)
                  .mapController
                  .animateCamera(cameraUpdate);

              settingindex();
            }
          } on SocketException catch (_) {
            _showSnackBar('Vérifiez votre connexion internet', context);
          }
        },
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            alert,
            Padding(
              padding: EdgeInsets.only(bottom: responsiveheight(4)),
              child: Text(
                'Envoyée par: $sender le $date',
                style: TextStyle(
                    fontSize: responsivetext(10.0),
                    color: Color(0xFF707070),
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ReceivedAlertStream extends StatelessWidget {
  Function settingindex;

  ReceivedAlertStream({this.settingindex});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .document(groupPath)
          .collection("receivedAlerts")
          .orderBy("envoyeLe", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xFF707070),
            ),
          );
        }

        List<Widget> alertList = [];

        final alerts = snapshot.data.documents;
        for (var alert in alerts) {
          final alertContent = alert.data['content'];
          final alertSender = alert.data['sender'];
          final alertIconName = alert.data['icon'];
          final alertDate = alert.data['envoyeLe'];
          final alertGeoP = alert.data['position']['geopoint'];

          var alertBubble = AlertBubbleBox(
            text: alertContent,
            icon: createIcon(alertIconName),
          );

          var receivedAlertBubble = ReceivedAlertBubble(
            sender: alertSender,
            alert: alertBubble,
            date: alertDate,
            geoPoint: alertGeoP,
            settingindex: settingindex,
          );
          alertList.add(receivedAlertBubble);
        }

        return ListView(
          children: alertList,
          padding: EdgeInsets.all(0),
        );
      },
    );
  }
}

class AlertBubbleBox extends StatelessWidget {
  final icon;
  final text;

  AlertBubbleBox({
    @required this.icon,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsiveradius(32.0, 1))),
      margin: EdgeInsets.symmetric(
          vertical: responsivewidth(5.0), horizontal: responsiveheight(20.0)),
      color: Colors.white,
      elevation: 5.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: responsivewidth(11.0),
                vertical: responsiveheight(11)),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Image(
                  image: AssetImage(
                    'images/circle.png',
                  ),
                  width: 52.0,
                ),
                Icon(
                  icon,
                  color: Color(0xFF707070),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: responsiveheight(25),
              top: responsiveheight(25),
              left: responsivewidth(8),
            ),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: responsivetext(16),
                  color: Color(0xFF707070),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

void addListnerToNotifier(Function ffunction) {
  valueNotifier.addListener(() async {
//    if (currentUser != notifSender) {
    var vaaa = _AlertScreenState(ffunction);
    vaaa.initState();
    await vaaa.showNotificationWithDefaultSound();
//    }
  });
}

class NotifStream extends StatelessWidget {
  Function ffunction;
  NotifStream({this.ffunction});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("Voyage").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        addListnerToNotifier(ffunction);

        final alerts = snapshot.data.documents;
        for (var alert in alerts) {
          var id = alert.documentID;

          if (id == _firestore.document(groupPath).documentID) {
            final groupJRA = alert.data['justReceivedAlert'];

            if (groupJRA != justReceivedAlert) {
              checkSenderUser();

              if ((notifSender != currentUser) || (notifSender != 'vide')) {
                valueNotifier.notifyListeners();
              }
              justReceivedAlert = groupJRA;
            }
          }
        }

        return Container();
      },
    );
  }
}

String notifSender;

Future<void> checkSenderUser() async {
  notifSender = 'vide';
  await _firestore
      .document(groupPath)
      .collection("receivedAlerts")
      .orderBy("envoyeLe", descending: true)
      .getDocuments()
      .then((QuerySnapshot doc) {
    if (doc.documents.isNotEmpty) {
      // List<DocumentSnapshot> ggglist = ggg.documents;
      if (doc.documents.first.data['sender'] != null) {
        var ggg = doc.documents.first;
        notifSender = ggg.data['sender'];
      }
    }
  });
  /*
  if(ggg!= null){
  List<DocumentSnapshot> ggglist = ggg.documents;
  if (ggglist[0].data['sender'] != null) {
    print('merdeeeeeeee :${ggglist[0].data['sender']}');
    notifSender = ggglist[0].data['sender'];

  }*/
}
