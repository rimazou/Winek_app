import 'package:winek/auth.dart';
import 'package:winek/screens/profile_screen.dart';
import 'package:winek/screens/resetmail.dart';
import 'package:winek/screens/resetpwd_screen.dart';
import 'package:flutter/material.dart';


import 'MapPage.dart';
import 'classes.dart';
import 'dataBase.dart';
import 'list_grp.dart';
import 'list_inv_grp.dart';
import 'nouveau_grp.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/welcome_screen.dart';


void main() => runApp(Authentication());
Color primarycolor = Color(0xff3B466B);
Color secondarycolor = Color(0xff389490);
Database data = Database(pseudo: 'hiba');

Utilisateur user = Utilisateur(
  pseudo: 'hiba',
  connecte: true,
  groupes: new List(),
  invitation_groupe: new List(),
  amis: <Utilisateur>[
    Utilisateur(
      pseudo: 'asma',
      groupes: new List(),
      invitation_groupe: new List(),
    ),
    Utilisateur(
      pseudo: 'dounia',
      groupes: new List(),
      invitation_groupe: new List(),
    ),
    Utilisateur(
      pseudo: 'rima',
      groupes: new List(),
      invitation_groupe: new List(),
    ),
    Utilisateur(
      pseudo: 'soumiya',
      groupes: new List(),
      invitation_groupe: new List(),
    ),
    Utilisateur(
      pseudo: 'lemis',
      groupes: new List(),
      invitation_groupe: new List(),
    ),
    Utilisateur(
      pseudo: 'ikram',
      groupes: new List(),
      invitation_groupe: new List(),
    ),
    Utilisateur(
      pseudo: 'rania',
      groupes: new List(),
      invitation_groupe: new List(),
    ),
  ],
);

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
      //initialRoute:  authService.connectedID()==null ? WelcomeScreen.id : Home.id,
      initialRoute: WelcomeScreen.id ,
      routes: {
        Home.id: (BuildContext context) => Home(), // la map
        WelcomeScreen.id : (context) => WelcomeScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        RegistrationScreen.id : (context) => RegistrationScreen(),
        ProfileScreen.id :(context) => ProfileScreen() ,
        ResetScreen.id :(context) => ResetScreen() ,
        ResetMailScreen.id :(context) => ResetMailScreen() ,
        NvLongTermePage.id: (context) => NvLongTermePage(),
        NvVoyagePage.id: (context) => NvVoyagePage(),
        ListGrpPage.id: (context) => ListGrpPage(),
        InvitationGrpPage.id: (context) => InvitationGrpPage(),


      },
    );
  }


}
