import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:winek/auth.dart';
import '../classes.dart';
import 'waitingSignout.dart';
import 'package:winek/screensRima/profile_screen.dart';
import 'package:winek/screensRima/resetmail.dart';
import 'profile_screen.dart';
import 'resetmail.dart';
import '../auth.dart';
import 'dart:async';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';


void getUserLocation() async {
  var val = authService.connectedID();
  if (val != null) // ca permetra de faire lappel seulement quand le user est co
      {
    try {
      var geolocator = Geolocator();
      var locationOptions = LocationOptions(
          accuracy: LocationAccuracy.high, distanceFilter: 10);
      StreamSubscription<Position> positionStream = geolocator
          .getPositionStream(locationOptions).listen(
              (Position position) {
            GeoFirePoint geoFirePoint = authService.geo.point(
                latitude: position.latitude, longitude: position.longitude);
            authService.userRef.document(val).updateData(
                {'location': geoFirePoint.data});
            print(geoFirePoint.data.toString());
          });
    } catch (e) {
      print('ya eu une erreur pour la localisation');
    }
  }
}

class LoginScreen extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String pwd, mail, errMl, errPwd;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            //tce widget permet de faire en sorte de scroller la page et pas la cacher avec le clavier
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),

                Container(

                  height: 120.0,
                  child: Image.asset('images/logo.png', fit: BoxFit.fill,height: 120.0,width: 120.0,),
                ),
                Text(
                  'Winek',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 26.0,
                    fontWeight: FontWeight.w900,
                    color:Color(0XFF3B466B),

                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'Connexion',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900,
                    color: Color(0XFF389490),//vert
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    mail = value;
                    setState(() {
                      !Validator.email(mail) ? errMl = null : errMl =
                      "Veuillez introduire une adresse valide";
                    });
                  },

                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',

                    // decorationColor: Color(0XFFFFCC00),//Font color change
                    //  backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
                  ),
                  decoration: InputDecoration(
                    labelText: 'Adresse mail',
                    hoverColor: Colors.black87,
                    errorText: errMl,
                    errorStyle: TextStyle(
                        color: Colors.red,
                        fontFamily: 'Montserrat',

                        fontWeight: FontWeight.bold),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  onChanged: (value) {
                    pwd=value ;
                    if (pwd.isEmpty) {
                      setState(() {
                        errPwd = 'Veuillez introduire un mot de passe';
                      });
                    }
                  },
                  obscureText: true,
                  autocorrect: false,

                  style: TextStyle(
                    fontFamily: 'Montserrat',

                    color: Colors.black87,
                    // decorationColor: Color(0XFFFFCC00),//Font color change
                    //  backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
                  ),
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.blueGrey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.blueGrey, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
                FlatButton(
                  child: Text(
                    'mot de passe oublie ?',
                    style: TextStyle(
                      color:Color(0XFF389490),

                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, ResetMailScreen.id);
                  },
                ),
                SizedBox(
                  height: 24.0,
                ),

                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        elevation: 5.0,
                        color:Color(0XFF3B466B),

                        child: MaterialButton(

                          onPressed: () => _testSignInWithGoogle() ,//_signInG(),
                          minWidth: 140.0,
                          height: 42.0,
                          child: Text(

                            'Google',

                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color:Colors.white,
                              fontWeight: FontWeight.bold,

                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color:Color(0XFF389490),

                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () => connect(),

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
                  ],
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }

/*  Future<FirebaseUser> _signInG() async {
    GoogleSignInAccount googleUser = await authService.googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = (await authService.auth.signInWithCredential(credential)) as FirebaseUser;
    print("signed in " + user.displayName);
    return user;
  }*/
  Future<String> _testSignInWithGoogle() async {
    final GoogleSignInAccount googleUser = await authService.googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = (await authService.auth.signInWithCredential(credential)).user;

    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await authService.auth.currentUser();
    assert(user.uid == currentUser.uid);

    print(  currentUser.email);
    if (user!=null) {
      Navigator.pushNamed(context, ProfileScreen.id);
    }
    else {
      print('failed google authetication');
    }
  }

  connect() async {
    try {
      final user = await authService.auth.signInWithEmailAndPassword(
          email: mail,
          password: pwd);
      if (user != null) { //getUserLocation();

        authService.userRef.document(user.user.uid).updateData(
            {'connecte': true});
        DocumentSnapshot snapshot = await authService.userRef.document(
            user.user.uid).get();
        while (snapshot == null) {
          showSpinner();
        }
        if (snapshot != null) {
          Utilisateur utilisateur = Utilisateur.fromdocSnapshot(snapshot);
          //  Navigator.pushNamed(context, Home.id);
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => ProfileScreen(utilisateur)
          ));
          print(utilisateur.pseudo);
          print(utilisateur.tel);
        }
      }
    }
    catch (logIn) {
      setState(() {
        if (logIn is PlatformException) {
          if (logIn.code == 'ERROR_USER_NOT_FOUND') {
            errMl = 'Utilisateur inexistant';
          } else {
            errMl = null;
          }
          if (logIn.code == 'ERROR_INVALID_EMAIL') {
            errMl = "Veuillez introduire une adresse valide";
          } else {
            errMl = null;
          }
          if (logIn.code == 'ERROR_WRONG_PASSWORD') {
            errPwd = 'Mot de passe errone';
          }
          else {
            errPwd = null;
          }
          if (logIn.code == 'ERROR_NETWORK_REQUEST_FAILED') {
            // erreur reseau internet faire qlq chose

          }
          else {
            errPwd = null;
          }
        }
      });
    }
  }

  Widget showSpinner() {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: SpinKitChasingDots(
              color: Colors.deepPurpleAccent,
            ),
          ),
        ),
      ),
    );
  }



}
