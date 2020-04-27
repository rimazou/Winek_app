
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:winek/screensHiba/MapPage.dart';
import 'package:winek/screensRima/waitingSignout.dart';
import 'package:winek/screensRima/login_screen.dart';
import 'package:winek/screensRima/profile_screen.dart';
import 'package:flutter/material.dart';

import '../auth.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}


class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column (
                children: <Widget>[
                  Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                  Text(
                    'Winek',

                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color:Color(0XFF3B466B),

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
                alignment : Alignment.bottomCenter,
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0,horizontal:5.0),
                      child: Material(
                        elevation: 5.0,
                        color:Color(0XFF389490),
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
                              color: Colors.white ,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold ,

                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0,horizontal:5.0),
                      child: Material(
                        color:Color(0XFF3B466B),
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
                              color: Colors.white ,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold ,

                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0,horizontal:5.0),
                      child: Material(
                        color:Color(0XFF3B466B),
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () {
                            //Go to registration screen.
                            Navigator.pushNamed(context,ProfileScreen.id);
                          },
                          minWidth: 140.0,
                          height: 42.0,
                          child: Text(
                            'Profile',

                            style: TextStyle(
                              color: Colors.white ,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold ,

                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0,horizontal:5.0),
                      child: Material(
                        color:Color(0XFF389490),
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => SignoutWait()
                            ));
                          },
                          minWidth: 140.0,

                          height: 42.0,
                          child: Text(
                            'Se deconnecter',

                            style: TextStyle(
                              color: Colors.white ,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold ,

                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 5.0),
                      child: Material(
                        color: Color(0XFF3B466B),
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () async {
                            await authService.connectedID().then((onVal) {
                              if (onVal != null) {
                                authService.getPseudo(onVal).then((val) {
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
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 5.0),
                      child: Material(
                        color: Color(0XFF389490),
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () {
                            // getUserLocation();
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
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 5.0),
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

