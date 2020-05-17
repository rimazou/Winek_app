import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:winek/screensHiba/MapPage.dart';
import 'package:winek/screensRima/waitingSignout.dart';
import 'package:winek/screensRima/login_screen.dart';
import 'package:winek/screensRima/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth.dart';
import '../classes.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import '../UpdateMarkers.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  _showSnackBar(String value, BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
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

    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                  Text(
                    'Winek',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0XFF3B466B),
                      fontSize: 40.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0),
                      child: Material(
                        elevation: 5.0,
                        color: Color(0XFF389490),
                        borderRadius: BorderRadius.circular(30.0),
                        child: MaterialButton(
                          onPressed: () {
                            //Go to login screen.
                            Navigator.pushNamed(context, LoginScreen.id);
                          },
                          minWidth: 140.0,
                          height: 42.0,
                          child: Text(
                            'Se connecter',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0),
                      child: Material(
                        color: Color(0XFF3B466B),
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () {
                            //Go to registration screen.
                            Navigator.pushNamed(context, RegistrationScreen.id);
                          },
                          minWidth: 140.0,
                          height: 42.0,
                          child: Text(
                            "S'inscrire",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0),
                      child: Material(
                        color: Color(0XFF3B466B),
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () async {
                            try {
                              final result = await InternetAddress.lookup(
                                  'google.com');
                              var result2 = await Connectivity()
                                  .checkConnectivity();
                              var b = (result2 != ConnectivityResult.none);

                              if (b && result.isNotEmpty &&
                                  result[0].rawAddress.isNotEmpty) {
                                String id = await authService.connectedID();
                                if (id != null) {
                                  DocumentSnapshot snapshot =
                                  await authService.userRef.document(id).get();
                                  while (snapshot == null) {
                                    showSpinner();
                                  }
                                  if (snapshot != null) {
                                    Utilisateur utilisateur =
                                    Utilisateur.fromdocSnapshot(snapshot);
                                    //  Navigator.pushNamed(context, Home.id);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileScreen(utilisateur)));
                                  }
                                }
                              }
                            } on SocketException catch (_) {
                              _showSnackBar(
                                  'Vérifiez votre connexion internet', context);
                            }
                          },
                          minWidth: 140.0,
                          height: 42.0,
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0),
                      child: Material(
                        color: Color(0XFF389490),
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignoutWait()));
                          },
                          minWidth: 140.0,
                          height: 42.0,
                          child: Text(
                            'Se deconnecter',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0),
                      child: Material(
                        color: Color(0XFF3B466B),
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () async {
                            await authService.connectedID().then((onVal) async {
                              try {
                                final result = await InternetAddress.lookup(
                                    'google.com');
                                var result2 = await Connectivity()
                                    .checkConnectivity();
                                var b = (result2 != ConnectivityResult.none);

                                if (b && result.isNotEmpty &&
                                    result[0].rawAddress.isNotEmpty) {
                                  await authService.connectedID().then((
                                      onVal) async {
                                    if (onVal != null) {
                                      await authService.getPseudo(onVal).then((val) {
                                        print(val);
                                      });
                                    }
                                  });
                                  await authService.isLog().then((log) {
                                    if (log) {
                                      print('yes log');
                                    } else {
                                      print('no log');
                                    }
                                  });
                                }
                              } on SocketException catch (_) {
                                _showSnackBar(
                                    'Vérifiez votre connexion internet',
                                    context);
                              }
                            });
                          },
                          minWidth: 140.0,
                          height: 42.0,
                          child: Text(
                            "who's connectede",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0),
                      child: Material(
                        color: Color(0XFF389490),
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () async {
                            try {
                              final result = await InternetAddress.lookup(
                                  'google.com');
                              var result2 = await Connectivity()
                                  .checkConnectivity();
                              var b = (result2 != ConnectivityResult.none);

                              if (b && result.isNotEmpty &&
                                  result[0].rawAddress.isNotEmpty) {
                                String id = await authService.connectedID();
                                // getUserLocation();
                                Provider.of<DeviceInformationService>(context,
                                    listen: false)
                                    .broadcastBatteryLevel(id);
                                Navigator.pushNamed(context, Home.id);
                                /* print('gonna return the stream builder');
                            return Container(
                              child: StreamBuilder(
                                  stream: authService.userRef.document(
                                      'oHFzqoSaM4RUDpqL9UF396aTCf72')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.done :
                                        print(snapshot.data['pseudo']);
                                        print(snapshot.data['photo']);
                                        break;
                                      case ConnectionState.waiting :
                                      case ConnectionState.none:
                                        print('not working');
                                        break;
                                      case ConnectionState.active:
                                        print("waiting");
                                        break;
                                    }
                                  }),
                            );*/
                              }
                            } on SocketException catch (_) {
                              _showSnackBar(
                                  'Vérifiez votre connexion internet', context);
                            }
                          },
                          minWidth: 140.0,
                          height: 42.0,
                          child: Text(
                            'go vers hiba',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0),
                      child: Material(
                        color: Color(0XFF389490),
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () {
                            showSpinner();
                          },
                          minWidth: 140.0,
                          height: 42.0,
                          child: Text(
                            'show spinner',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    );
  }

  Widget showSpinner() {
    return SafeArea(
      child: Scaffold(
        body: SpinKitChasingDots(
          color: Colors.deepPurpleAccent,
        ),
      ),
    );
  }
}
