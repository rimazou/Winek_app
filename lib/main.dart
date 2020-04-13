import 'package:winek/screens/profile_screen.dart';
import 'package:winek/screens/resetmail.dart';
import 'package:winek/screens/resetpwd_screen.dart';
import 'package:flutter/material.dart';


import 'auth.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/welcome_screen.dart';


void main() => runApp(Authentication());

class Authentication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        ),
      ),
      debugShowCheckedModeBanner: false ,
      initialRoute: WelcomeScreen.id ,
      routes: {
        WelcomeScreen.id : (context) => WelcomeScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        RegistrationScreen.id : (context) => RegistrationScreen(),
        ProfileScreen.id :(context) => ProfileScreen() ,
        ResetScreen.id :(context) => ResetScreen() ,
        ResetMailScreen.id :(context) => ResetMailScreen() ,


      },
    );
  }



}
