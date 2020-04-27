import 'package:winek/auth.dart';
import 'package:winek/screensRima/profile_screen.dart';
import 'package:winek/screensRima/resetmail.dart';
import 'package:winek/screensRima/resetpwd_screen.dart';
import 'package:flutter/material.dart';
import 'package:winek/screensSoum/usersListScreen.dart';
import 'screensHiba/MapPage.dart';
import 'classes.dart';
import 'dataBasehiba.dart';
import 'screensSoum/friendRequestScreen.dart';
import 'screensSoum/friendsListScreen.dart';
import 'screensHiba/list_grp.dart';
import 'screensHiba/list_inv_grp.dart';
import 'screensHiba/nouveau_grp.dart';
import 'screensRima/login_screen.dart';
import 'screensRima/register_screen.dart';
import 'screensRima/welcome_screen.dart';
import 'UpdateMarkers.dart';
import 'package:provider/provider.dart';

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
    return  ChangeNotifierProvider<UpdateMarkers>(
       create:(BuildContext context) =>UpdateMarkers(),
      child:  MaterialApp(
      theme: ThemeData.light().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        ),
      ),
      debugShowCheckedModeBanner: false ,
      //initialRoute:  authService.connectedID()==null ? WelcomeScreen.id : Home.id,
      initialRoute: WelcomeScreen.id,
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
        FriendRequestListScreen.id: (context) => FriendRequestListScreen(),
        UsersListScreen.id: (context) => UsersListScreen(),
        FriendsListScreen.id: (context) => FriendsListScreen(),

      },
       ),
    );
  }


}
