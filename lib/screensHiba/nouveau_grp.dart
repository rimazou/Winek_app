import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:winek/auth.dart';
import 'MapPage.dart';
import '../main.dart';
import '../classes.dart';
import '../dataBasehiba.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'DestinationFromFav.dart';
import 'dart:io';
import 'dart:ui';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

Databasegrp data = Databasegrp();
bool _alerte_nom = false;
bool _alerte_mbr = false;
String nom_grp = "";
var _controller;
Groupe nv_grp;
String _destinationAdr;
Map<String, dynamic> _destination;
List<Map<dynamic, dynamic>> membres;
bool _loading;
final _firestore = Firestore.instance;
GoogleMapsPlaces _places =
GoogleMapsPlaces(apiKey: "AIzaSyBV4k4kXJRfG5RmCO3OF24EtzEzZcxaTrg");

void createlongterme() async {
// get the current user info
  Map<String, String> user = {'pseudo': '', 'id': ''};
  user['id'] = await authService.connectedID();
  user['pseudo'] = await Firestore.instance
      .collection('Utilisateur')
      .document(user['id'])
      .get()
      .then((Doc) {
    return Doc.data['pseudo'];
  });
  print("user:$user");
// creationg the doc of the grp
  DocumentReference ref = await _firestore.collection('LongTerme').add({
    'nom': nom_grp,
    'admin': user['pseudo'],
    'membres': [
      user
    ], // since he's the admin, others have to accept the invitation first
  });
  Geoflutterfire geo = Geoflutterfire();
  GeoFirePoint point =
  geo.point(latitude: 36.7525, longitude: 3.041969999999992);

  await _firestore
      .document(ref.path)
      .collection('members')
      .document(user['id'])
      .setData({
    'position': point.data,
  });
  GeoPoint position;
  GeoFirePoint geoFirePoint;
//  Geoflutterfire geo = Geoflutterfire();
  _firestore
      .collection('Utilisateur')
      .document(user['id'])
      .snapshots(includeMetadataChanges: true)
      .listen((DocumentSnapshot documentSnapshot) {
    position = documentSnapshot.data['location']['geopoint'];
/*await _firestore.collection('Utilisateur').document(userID).get().then((DocumentSnapshot ds) {
      position = ds.data['location']['geopoint'];
    });*/
    geoFirePoint =
        geo.point(latitude: position.latitude, longitude: position.longitude);
    _firestore
        .document(ref.path)
        .collection('members')
        .document(user['id'])
        .updateData({'position': geoFirePoint.data});
  });
  print('member doc added');
  Map grp = {'chemin': ref.path, 'nom': nom_grp};
  print(grp);
// adding that grp to member's invitations liste.
  for (Map m in membres) {
    DocumentSnapshot doc =
    await Firestore.instance.collection('UserGrp').document(m['id']).get();
    if (doc.exists) {
      if (doc.data.containsKey('invitations')) {
        doc.reference.updateData({
          'invitations': FieldValue.arrayUnion([grp])
        });
      } else {
        doc.reference.updateData({
          'invitations': [grp]
        });
      }
    } else {
      Firestore.instance.collection('UserGrp').document(m['id']).setData({
        'pseudo': m['pseudo'],
        'invitations': [grp]
      });
    }
  }
//adding the grp into the admin list of grp
  DocumentSnapshot userdoc =
  await Firestore.instance.collection('UserGrp').document(user['id']).get();
  if (userdoc.exists) {
    if (userdoc.data.containsKey('groupes')) {
      userdoc.reference.updateData({
        'groupes': FieldValue.arrayUnion([grp])
      });
    } else {
      userdoc.reference.updateData({
        'groupes': [grp]
      });
    }
  } else {
    Firestore.instance.collection('UserGrp').document(user['id']).setData({
      'pseudo': user['pseudo'],
      'groupes': [grp]
    });
  }
}

class NvLongTermePage extends StatefulWidget {
  @override
  _NvLongTermePageState createState() => _NvLongTermePageState();
  static String id = 'nv_long_terme';
}

class _NvLongTermePageState extends State<NvLongTermePage> {
  bool _loading = false;

  @override
  void initState() {
    membres = List<Map>();
    _controller = TextEditingController();
    _loading = false;
  }

  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Spacer(
              flex: 1,
            ),
            Center(
              child: Text(
                'Nouveau groupe',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff3B466B),
                ),
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Container(
              height: 43,
              width: 321,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color.fromRGBO(59, 70, 107, 0.3),
                    blurRadius: 7.0,
                    offset: Offset(0.0, 0.75),
                  )
                ],
              ),
              child: TextField(
                onTap: () {
                  setState(() {
                    _alerte_nom = false;
                  });
                },
                controller: _controller,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: '   Nom du groupe',
                  hintStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff707070),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _alerte_nom ? Colors.red : primarycolor,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: secondarycolor,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child: Text(
                '    Ajoutez vos amis',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: _alerte_mbr ? Colors.red : Color(0xff707070),
                ),
              ),
            ),
            Container(
              width: 350,
              height: 250,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(59, 70, 107, 0.3),
              ),
              child: FriendList((var member) {
                membres.contains(member)
                    ? membres.remove(member)
                    : membres.add(member);
              }),
            ),
            Spacer(
              flex: 1,
            ),
            Container(
              height: 38,
              width: 155,
              decoration: BoxDecoration(
                color: Color(0xff389490),
                borderRadius: BorderRadius.circular(50),
              ),
              child: FlatButton(
                onPressed: () async {
                  print(_controller.text);
                  print(membres.length);
                  setState(() {
                    if (_controller.text.isEmpty) {
                      _alerte_nom = true;
                    } else {
                      _alerte_nom = false;
                      nom_grp = _controller.text;
                    }
                    if (membres.isEmpty) {
                      _alerte_mbr = true;
                    } else {
                      _alerte_mbr = false;
                    }
                    if (nom_grp.isNotEmpty && membres.isNotEmpty) {
                      setState(() {
                        _loading = true;
                      });
                      createlongterme();
                      setState(() {
                        _loading = false;
                      });
                      Navigator.pushNamed(context, Home.id);
                    }
                  });
                },
                child: Center(
                  child: Text(
                    'Créer',
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Spacer(
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}

//----------------------------------------------------------------------------------//
void createvoyage() async {
// creationg the doc of the grp
  Map user = {'pseudo': '', 'id': ''};
  user['id'] = await authService.connectedID();
  user['pseudo'] = await Firestore.instance
      .collection('Utilisateur')
      .document(user['id'])
      .get()
      .then((Doc) {
    return Doc.data['pseudo'];
  });
// creationg the doc of the grp
  DocumentReference ref = await _firestore.collection('Voyage').add({
    'nom': nom_grp,
    'admin': user['pseudo'],
    'destination': _destination,
    'membres': [user],
    'justReceivedAlert': false,
// since he's the admin, others have to accept the invitation first
  });
  print('voyage cree');
//creating the subcollection doc for location
  Geoflutterfire geo = Geoflutterfire();
  GeoFirePoint point = geo.point(latitude: 0.0, longitude: 0.0);

  await _firestore
      .document(ref.path)
      .collection('members')
      .document(user['id'])
      .setData({
    'position': point.data,
    'arrive': false,
  });

  GeoPoint position;
  GeoFirePoint geoFirePoint;
//  Geoflutterfire geo = Geoflutterfire();
  _firestore
      .collection('Utilisateur')
      .document(user['id'])
      .snapshots(includeMetadataChanges: true)
      .listen((DocumentSnapshot documentSnapshot) {
    position = documentSnapshot.data['location']['geopoint'];
/*await _firestore.collection('Utilisateur').document(userID).get().then((DocumentSnapshot ds) {
      position = ds.data['location']['geopoint'];
    });*/
    geoFirePoint =
        geo.point(latitude: position.latitude, longitude: position.longitude);
    _firestore
        .document(ref.path)
        .collection('members')
        .document(user['id'])
        .updateData({'position': geoFirePoint.data});
  });
  print('member doc added');
  await _firestore
      .document(ref.path)
      .collection('fermeture')
      .document('fermeture')
      .setData({'fermer': false});

  Map grp = {'chemin': ref.path, 'nom': nom_grp};
// adding that grp to member's invitations liste:
  for (Map m in membres) {
    DocumentSnapshot doc =
    await Firestore.instance.collection('UserGrp').document(m['id']).get();
    if (doc.exists) {
      if (doc.data.containsKey('invitations')) {
        doc.reference.updateData({
          'invitations': FieldValue.arrayUnion([grp])
        });
      } else {
        doc.reference.updateData({
          'invitations': [grp]
        });
      }
    } else {
      Firestore.instance.collection('UserGrp').document(m['id']).setData({
        'pseudo': m['pseudo'],
        'invitations': [grp]
      });
    }
  }
  print('invitations sent');
//adding it to admin list of grp
  DocumentSnapshot userdoc =
  await Firestore.instance.collection('UserGrp').document(user['id']).get();
  if (userdoc.exists) {
    if (userdoc.data.containsKey('groupes')) {
      userdoc.reference.updateData({
        'groupes': FieldValue.arrayUnion([grp])
      });
    } else {
      userdoc.reference.updateData({
        'groupes': [grp]
      });
    }
  } else {
    Firestore.instance.collection('UserGrp').document(user['id']).setData({
      'pseudo': user['pseudo'],
      'groupes': [grp]
    });
  }
  print('groupe added');
}

class NvVoyagePage extends StatefulWidget {
  @override
  _NvVoyagePageState createState() => _NvVoyagePageState();
  static String id = 'nv_voyage';
}

class _NvVoyagePageState extends State<NvVoyagePage> {
  @override
  void initState() {
    membres = new List();
    _destinationAdr = 'votre destination';
    _controller = TextEditingController();
    _loading = false;
  }

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
      action: new SnackBarAction(
          label: 'Ok',
          onPressed: () {
            print('press Ok on SnackBar');
          }),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Spacer(
              flex: 2,
            ),
            Center(
              child: Text(
                'Nouveau groupe',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff3B466B),
                ),
              ),
            ),
            Spacer(
              flex: 2,
            ),
            Container(
              height: 40,
              width: 350,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: primarycolor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    'vers ',
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '$_destinationAdr',
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      try {
                        final result =
                        await InternetAddress.lookup('google.com');
                        var result2 = await Connectivity().checkConnectivity();
                        var b = (result2 != ConnectivityResult.none);

                        if (b &&
                            result.isNotEmpty &&
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
                          if (p != null) {
                            PlacesDetailsResponse detail =
                            await _places.getDetailsByPlaceId(p.placeId);
                            var placeId = p.placeId;
                            String placeIdToString = "$placeId";
                            double lat = detail.result.geometry.location.lat;
                            double lng = detail.result.geometry.location.lng;
                            PlacesDetailsResponse place = await _places
                                .getDetailsByPlaceId(placeIdToString);
                            final placeDetail = place.result;
                            setState(() {
                              _destinationAdr = placeDetail.formattedAddress;
                              print(_destinationAdr);
                              _destination = {
                                'latitude': lat,
                                'longitude': lng,
                                'adresse': _destinationAdr
                              };
                            });
                          }

                          print(_destination);
                        }
                      } on SocketException catch (_) {
                        _showSnackBar('Vérifiez votre connexion internet');
                      }
                    },
                    icon: Icon(Icons.mode_edit),
                    color: Color(0xff707070),
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() async {
                        _destination = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GetDestination()));
                        _destinationAdr = _destination['adresse'];
                      });
                    },
                    icon: Icon(Icons.star),
                    color: Color(0xff707070),
                    iconSize: 20,
                  )
                ],
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Container(
              height: 43,
              width: 321,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color.fromRGBO(59, 70, 107, 0.3),
                    blurRadius: 7.0,
                    offset: Offset(0.0, 0.75),
                  )
                ],
              ),
              child: TextField(
                onTap: () {
                  setState(() {
                    _alerte_nom = false;
                  });
                },
                controller: _controller,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: '   Nom du groupe',
                  hintStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff707070),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _alerte_nom ? Colors.red : primarycolor,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: secondarycolor,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child: Text(
                '    Ajoutez vos amis',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: _alerte_mbr ? Colors.red : Color(0xff707070),
                ),
              ),
            ),
            Container(
              width: 350,
              height: 250,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(59, 70, 107, 0.3),
              ),
              child: FriendList((var member) {
                membres.contains(member)
                    ? membres.remove(member)
                    : membres.add(member);
                print(membres.toString());
              }),
            ),
            Spacer(
              flex: 1,
            ),
            Container(
              height: 38,
              width: 155,
              decoration: BoxDecoration(
                color: Color(0xff389490),
                borderRadius: BorderRadius.circular(50),
              ),
              child: FlatButton(
                onPressed: () {
                  print(_controller.text);
                  print(membres.length);
                  setState(() {
                    if (_controller.text.isEmpty) {
                      _alerte_nom = true;
                    } else {
                      _alerte_nom = false;
                      nom_grp = _controller.text;
                    }
                    if (membres.isEmpty) {
                      _alerte_mbr = true;
                    } else {
                      _alerte_mbr = false;
                    }
                    if (nom_grp.isNotEmpty && membres.isNotEmpty) {
                      setState(() {
                        _loading = true;
                      });
                      createvoyage();
                      setState(() {
                        _loading = false;
                      });
                      Navigator.pushNamed(context, Home.id);
                    }
                  });
                },
                child: Center(
                  child: Text(
                    'Créer',
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Spacer(
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}

//----------------------------------------------------------------------------------//

class FriendList extends StatelessWidget {
  final Function _function;

  FriendList(this._function);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Map<dynamic, dynamic>>>.value(
        value: getlistfreind().asStream(),
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: FriendsList(_function),
        ));
  }
}

class FriendsList extends StatefulWidget {
  final Function _function;

  FriendsList(this._function);

  @override
  _FriendsListState createState() => _FriendsListState(_function);
}

class _FriendsListState extends State<FriendsList> {
  final Function _function;

  _FriendsListState(this._function);

  @override
  Widget build(BuildContext context) {
    final friends = Provider.of<List<Map<dynamic, dynamic>>>(context);
    int count;
    if (friends != null) {
      count = friends.length;
    } else {
      count = 0;
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            onTap: () {
              setState(() {
                _function(friends[index]);
              });
            },
            title: Text(
              friends[index]['pseudo'],
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                color: Color(0xff707070),
              ),
            ),
            leading: Icon(
              Icons.person,
              color: primarycolor,
              size: 30,
            ),
            trailing: membres.contains(friends[index])
                ? Icon(
              Icons.done,
              color: secondarycolor,
              size: 30,
            )
                : Icon(
              Icons.add_circle_outline,
              color: secondarycolor,
              size: 30,
            ),
          ),
        );
      },
    );
  }
}

Future<List<Map<dynamic, dynamic>>> getlistfreind() async {
  String id = await authService.connectedID();
  print(id);
  List<Map<dynamic, dynamic>> friendsid = List<Map>();
  await Firestore.instance
      .collection('Utilisateur')
      .document(id)
      .get()
      .then((DocumentSnapshot doc) {
    friendsid = List<Map>.from(doc.data['amis']);
  });
  print(friendsid);
  /* List<dynamic> pseudos = List();
  for (String id in friendsid) {
    await Firestore.instance
        .collection('Utilisateur')
        .document(id)
        .get()
        .then((DocumentSnapshot doc) {
      pseudos.add(doc.data['pseudo']);
    });
  }
  print(pseudos);
  List<Map<dynamic, dynamic>> friendlist = List();
  for (int index = 0; index < friendsid.length; index++) {
    friendlist.add({'pseudo': pseudos[index], 'id': friendsid[index]});
  } */
  return friendsid;
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

void onError(PlacesAutocompleteResponse response) {
  homeScaffoldKey.currentState.showSnackBar(
    SnackBar(content: Text(response.errorMessage)),
  );
}
