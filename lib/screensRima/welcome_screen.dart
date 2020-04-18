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
                            _signOut() ;
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
                          onPressed: () {
                            authService.connectedID();
                            print(authService.isFirst());
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _signOut (){
    authService.isUserLogged()==true ? print('true') : print ('false') ;

    authService.auth.signOut();
    authService.googleSignIn.signOut();
    authService.isUserLogged()==true ? print('true') : print ('false') ;
    if (authService.loggedIn== null) {
      print('nuuulll ');
    }
    else{
      print ('got prob tjr connecte');
    }
  }


/*_loggedOut (){
    authService.googleSignIn.signOut();
  } by  google */


}
