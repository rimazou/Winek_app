import 'dart:ui';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import '../classes.dart';
import '../dataBasehiba.dart';
import 'nouveau_grp.dart';
import 'list_grp.dart';
import '../main.dart';

const kGoogleApiKey = "AIzaSyAqKjL3o1J_Hn45ieKwEo9g8XLmj9CqhSc";
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
Database data = Database(pseudo: 'hiba');
//google maps stuffs
GoogleMapController mapController;
String searchAddr;
var globalContext;

void _onMapCreated(GoogleMapController controller) {
  mapController = controller;
}
/*
void _openDrawer(BuildContext context) {
  _scaffoldKey.currentState.openDrawer();
}
 */

searchandNavigate() {
  Geolocator().placemarkFromAddress(searchAddr).then((result) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target:
            LatLng(result[0].position.latitude, result[0].position.longitude),
        zoom: 10.0)));
  });
}

class Home extends StatefulWidget {
  static const String id = 'map';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
//variables
  int index = 0;
  bool _visible = true;
  Color c1 = const Color.fromRGBO(0, 0, 60, 0.8);
  Color c2 = const Color(0xFF3B466B);
  Color myWhite = const Color(0xFFFFFFFF);

//fin variables
  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);

      print(lat);
      print(lng);
    }
  }

  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      bottomNavigationBar: bottomNavBar,
      floatingActionButton: flaotButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            mapToolbarEnabled: true,
            onMapCreated: _onMapCreated,
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
              color: Color.fromRGBO(255, 255, 255, 0.3),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.02,
                    top: MediaQuery.of(context).size.height * 0.03,
                    child: MaterialButton(
                      onPressed: () {
                        // _closeDrawer(context);
                        setState(() {
                          index = 0;
                          _visible = true;
                        });
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: size.height * 0.6,
                      width: size.width * 0.65,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(59, 70, 107, 0.8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: size.width * 0.25,
                            width: size.width * 0.4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: size.width * 0.15,
                                  width: size.width * 0.15,
                                  child: CircleAvatar(
                                    backgroundColor: myWhite,
                                    child:
                                        //TODO replace by the photo
                                        Icon(
                                      Icons.person_outline,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    data.pseudo,
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 60.0,
                                    vertical: 0,
                                  ),
                                  onTap: null,
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
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 60.0,
                                    vertical: 0,
                                  ),
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
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 60.0,
                                    vertical: 0,
                                  ),
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
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 60.0,
                                    vertical: 0,
                                  ),
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
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.45,
                    bottom: MediaQuery.of(context).size.height * 0.1,
                    child: Container(
                      height: 40,
                      width: 40,
                      child: FloatingActionButton(
                        onPressed: () {},
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Color(0xFFFFFFFF),
                        child: Transform(
                          transform: Matrix4.rotationX(170),
                          child:
                              Icon(Icons.directions_run, color: c2, size: 32.0),
                        ),
                      ),
                    ),
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
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromRGBO(59, 70, 107, 0.5)),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Spacer(
                              flex: 1,
                            ),
                            Text("Créer un groupe ",
                                style: TextStyle(
                                  fontSize: 17,
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
                                  size: 75,
                                ),
                                contenu: Text(
                                  "de voyage",
                                  style: TextStyle(
                                      fontSize: 14,
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
                                Navigator.pushNamed(
                                    context, NvLongTermePage.id);
                              },
                              child: Bouton(
                                icon: Icon(
                                  Icons.people,
                                  color: Color(0xff707070),
                                  size: 75,
                                ),
                                contenu: Text(
                                  "a long terme",
                                  style: TextStyle(
                                      fontSize: 14,
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
          ]),
        ],
      ),
    );
  }

  Widget get ResearchBar {
    return Positioned(
      left: size.width * 0.075,
      top: size.height * 0.04,
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: Container(
          height: size.height * 0.07,
          width: size.width * 0.85,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0), color: Colors.white),
          child: Stack(
            //alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                left: 0,
                // top:size.height*0.07*0.5,
                child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Color(0xFF3B466B),
                    ),
                    onPressed: () {
                      //  _openDrawer(context);
                      setState(() {
                        index = 1;
                        _visible = !_visible;
                      });
                    },
                    iconSize: 30.0),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.3, vertical: 0.001),
                child: TextField(
                  style: TextStyle(
                      fontFamily: 'Montserrat', color: myWhite, fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Recherche',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15.0),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                // top:size.height*0.5,
                child: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Color(0xFF3B466B),
                    ),
                    onPressed: searchandNavigate,
                    iconSize: 30.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get flaotButton {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: FloatingActionButton(
        heroTag: null,
        backgroundColor: Color(0xFF389490),
        child: Icon(Icons.group_add, size: 32.0),
        onPressed: () {
          setState(() {
            index = 2;
            _visible = !_visible;
          });
        },
      ),
    );
    //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked;
  }

  Widget get bottomNavBar {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Color(0xFF3B466B),
          notchMargin: 10,
          child: Container(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.group,
                          size: 32.0,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            index = 0;
                          });
                          Navigator.pushNamed(context, ListGrpPage.id);
                        },
                      ),
                    ],
                  ),
                ),

                // Right Tab bar icons

                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    //se localiser //zoom ect
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: 32.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MapVoyagePage extends StatefulWidget {
  Voyage groupe;

  MapVoyagePage(this.groupe);

  @override
  _MapVoyagePageState createState() => _MapVoyagePageState(groupe);
}

class _MapVoyagePageState extends State<MapVoyagePage> {
  Voyage groupe;
  bool _visible = true;
  Color c1 = const Color.fromRGBO(0, 0, 60, 0.8);
  Color c2 = const Color(0xFF3B466B);
  Color myWhite = const Color(0xFFFFFFFF);
  int index;

  _MapVoyagePageState(this.groupe);

  @override
  void initState() {
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var it = groupe.membres.iterator;
    List<Widget> liste = new List();
    while (it.moveNext()) {
      it.current;
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
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF707070),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      it.current,
                      //overflow:TextOverflow.fade,

                      //textScaleFactor: 0.4,
                      style: TextStyle(
                        fontFamily: 'MontSerrat',
                        fontSize: 10,
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
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      // key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            mapToolbarEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(36.7525000, 3.0419700),
              zoom: 11.0,
            ),
          ),
          IndexedStack(index: index, children: <Widget>[
            //index = 0 :
            Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  top: 30.0,
                  // top:size.height*0.07*0.5,
                  child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Color(0xFF3B466B),
                        size: 30,
                      ),
                      onPressed: () {
                        // _openDrawer(context);
                        setState(() {
                          index = 1;
                          //_visible = !_visible;
                        });
                        print(index);
                      },
                      iconSize: 30.0),
                ),
                Positioned(
                  top: 30.0,
                  right: 15.0,
                  left: 35.0,
                  child: Container(
                    height: 50.0,
                    width: 250,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Recherche',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(left: 15.0, top: 15.0),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: searchandNavigate,
                              iconSize: 30.0)),
                      onChanged: (val) {
                        setState(() {
                          searchAddr = val;
                        });
                      },
                    ),
                  ),
                ),
                //liste of members
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
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: liste,
                    ),
                  ),
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
                            Navigator.pushNamed(context, ListGrpPage.id);
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
            // the drawer, index=1
            Container(
              width: size.width,
              color: Color.fromRGBO(255, 255, 255, 0.3),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.02,
                    top: MediaQuery.of(context).size.height * 0.03,
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          index = 0;
                        });
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: size.height * 0.6,
                      width: size.width * 0.65,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(59, 70, 107, 0.8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: size.width * 0.25,
                            width: size.width * 0.4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: size.width * 0.15,
                                  width: size.width * 0.15,
                                  child: CircleAvatar(
                                    backgroundColor: myWhite,
                                    child:
                                        //TODO replace by the photo
                                        Icon(
                                      Icons.person_outline,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    data.pseudo,
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 60.0,
                                    vertical: 0,
                                  ),
                                  onTap: null,
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
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 60.0,
                                    vertical: 0,
                                  ),
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
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 60.0,
                                    vertical: 0,
                                  ),
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
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 60.0,
                                    vertical: 0,
                                  ),
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
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.45,
                    bottom: MediaQuery.of(context).size.height * 0.1,
                    child: Container(
                      height: 40,
                      width: 40,
                      child: FloatingActionButton(
                        onPressed: () {},
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Color(0xFFFFFFFF),
                        child: Transform(
                          transform: Matrix4.rotationX(170),
                          child:
                              Icon(Icons.directions_run, color: c2, size: 32.0),
                        ),
                      ),
                    ),
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
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromRGBO(59, 70, 107, 0.5)),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Spacer(
                              flex: 1,
                            ),
                            Text("Créer un groupe ",
                                style: TextStyle(
                                  fontSize: 17,
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
                                  size: 75,
                                ),
                                contenu: Text(
                                  "de voyage",
                                  style: TextStyle(
                                      fontSize: 14,
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
                                  size: 75,
                                ),
                                contenu: Text(
                                  "a long terme",
                                  style: TextStyle(
                                      fontSize: 14,
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
          ]),
        ],
      ),
    );
  }
}

class MapLongTermePage extends StatefulWidget {
  LongTerme groupe;

  MapLongTermePage(this.groupe);

  @override
  _MapLongTermePageState createState() => _MapLongTermePageState(groupe);
}

class _MapLongTermePageState extends State<MapLongTermePage> {
  LongTerme groupe;
  bool _visible = true;
  Color c1 = const Color.fromRGBO(0, 0, 60, 0.8);
  Color c2 = const Color(0xFF3B466B);
  Color myWhite = const Color(0xFFFFFFFF);
  int index;

  _MapLongTermePageState(this.groupe);

  @override
  void initState() {
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var it = groupe.membres.iterator;
    List<Widget> liste = new List();
    while (it.moveNext()) {
      it.current;
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
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF707070),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      it.current,
                      style: TextStyle(
                        fontFamily: 'MontSerrat',
                        fontSize: 10,
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
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      // key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            mapToolbarEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(36.7525000, 3.0419700),
              zoom: 11.0,
            ),
          ),
          IndexedStack(index: index, children: <Widget>[
            //index = 0 :
            Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  // top:size.height*0.07*0.5,
                  child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Color(0xFF3B466B),
                      ),
                      onPressed: () {
                        // _openDrawer(context);
                        setState(() {
                          index = 1;
                          _visible = !_visible;
                        });
                      },
                      iconSize: 30.0),
                ),
                Positioned(
                  top: 30.0,
                  right: 15.0,
                  left: 15.0,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Recherche',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(left: 15.0, top: 15.0),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: searchandNavigate,
                              iconSize: 30.0)),
                      onChanged: (val) {
                        setState(() {
                          searchAddr = val;
                        });
                      },
                    ),
                  ),
                ),
                //liste of members
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
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: liste,
                    ),
                  ),
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
                            Navigator.pushNamed(context, ListGrpPage.id);
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
            // the drawer, index=1
            Container(
              width: size.width,
              color: Color.fromRGBO(255, 255, 255, 0.3),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.02,
                    top: MediaQuery.of(context).size.height * 0.03,
                    child: MaterialButton(
                      onPressed: () {
                        // _closeDrawer(context);
                        setState(() {
                          index = 0;
                          _visible = true;
                        });
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: size.height * 0.6,
                      width: size.width * 0.65,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(59, 70, 107, 0.8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: size.width * 0.25,
                            width: size.width * 0.4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: size.width * 0.15,
                                  width: size.width * 0.15,
                                  child: CircleAvatar(
                                    backgroundColor: myWhite,
                                    child:
                                        //TODO replace by the photo
                                        Icon(
                                      Icons.person_outline,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    data.pseudo,
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 60.0,
                                    vertical: 0,
                                  ),
                                  onTap: null,
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
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 60.0,
                                    vertical: 0,
                                  ),
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
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 60.0,
                                    vertical: 0,
                                  ),
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
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 60.0,
                                    vertical: 0,
                                  ),
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
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.45,
                    bottom: MediaQuery.of(context).size.height * 0.1,
                    child: Container(
                      height: 40,
                      width: 40,
                      child: FloatingActionButton(
                        onPressed: () {},
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Color(0xFFFFFFFF),
                        child: Transform(
                          transform: Matrix4.rotationX(170),
                          child:
                              Icon(Icons.directions_run, color: c2, size: 32.0),
                        ),
                      ),
                    ),
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
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromRGBO(59, 70, 107, 0.5)),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Spacer(
                              flex: 1,
                            ),
                            Text("Créer un groupe ",
                                style: TextStyle(
                                  fontSize: 17,
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
                                  size: 75,
                                ),
                                contenu: Text(
                                  "de voyage",
                                  style: TextStyle(
                                      fontSize: 14,
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
                                  size: 75,
                                ),
                                contenu: Text(
                                  "a long terme",
                                  style: TextStyle(
                                      fontSize: 14,
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
            borderRadius: BorderRadius.circular(10),
            color: Color.fromRGBO(59, 70, 107, 0.5)),
        child: Center(
          child: Column(
            children: <Widget>[
              Spacer(
                flex: 1,
              ),
              Text("Créer un groupe ",
                  style: TextStyle(
                    fontSize: 17,
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
                    size: 75,
                  ),
                  contenu: Text(
                    "de voyage",
                    style: TextStyle(
                        fontSize: 14,
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
                    size: 75,
                  ),
                  contenu: Text(
                    "a long terme",
                    style: TextStyle(
                        fontSize: 14,
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
        height: 106,
        width: 113,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
