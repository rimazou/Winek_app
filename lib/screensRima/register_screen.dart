import 'dart:core';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:winek/auth.dart';
import 'package:winek/classes.dart';
import 'package:winek/main.dart';
import 'package:winek/screensHiba/MapPage.dart';
import 'package:winek/ui/size_config.dart';
import 'profile_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:password_strength/password_strength.dart';
import 'package:winek/UpdateMarkers.dart';
import 'package:path/path.dart' as p;

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class RegistrationScreen extends StatefulWidget {
  static const String id = 'register';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email,
      pw,
      pwd,
      pseudo,
      tel,
      pic =
          "https://images.unsplash.com/photo-1485873295351-019c5bf8bd2e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80";
  File _image;
  String _uploadedFileURL;
  bool tap = false;
  _showSnackBar(String value) {
    final snackBar = new SnackBar(
      content: new Text(
        value,
        style: TextStyle(
            color: Colors.white,
            fontSize: responsivetext(14.0),
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

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
          child: SpinKitChasingDots(
            color: Color(0XFF389490),
          ));
    } else {
      return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(responsiveheight(28.0)),
            child: AppBar(
              backgroundColor: Colors.white30,
              elevation: 0.0,
              iconTheme: IconThemeData(
                color: Colors.black54,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: responsiveheight(140),
                          ),
                          Container(
                            height: responsiveheight(800.0),
                            width: responsivewidth(320.0),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: responsiveheight(190),
                          ),
                          Container(
                            height: responsiveheight(400.0),
                            width: responsivewidth(320.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey[300],
                                width: responsivewidth(3),
                              ),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.grey[200],
                                  blurRadius: responsiveradius(20.0, 1),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(
                                  responsiveradius(20, 1)),
                            ),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: responsiveheight(80.0),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: responsivewidth(20)),
                                  child: Container(
                                    height: responsiveheight(42),
                                    child: TextField(


                                      onChanged: (value) {
                                        pseudo = value;
                                        pseudoExist();
                                      },
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'Montserrat',

                                        // decorationColor: Color(0XFFFFCC00),//Font color change
                                        //  backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Pseudo',
                                        errorText: errPs,
                                        errorStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: responsiveheight(10.0),
                                          horizontal: responsivewidth(20.0),),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  responsiveradius(32.0, 1))),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0XFF3B466B),
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0XFF389490), //vert
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: responsiveheight(2.0),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: responsivewidth(20),),
                                  child: Container(
                                    height: responsiveheight(42),
                                    child: TextField(
                                      keyboardType: TextInputType.emailAddress,
                                      onChanged: (value) {
                                        email = value;
                                        setState(() {
                                          !Validator.email(email)
                                              ? errMl = null
                                              : errMl =
                                          "Veuillez introduire une adresse valide";
                                          mailExist();
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
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20.0),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0XFF3B466B),
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0XFF389490), //vert
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: responsiveheight(2.0),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: responsivewidth(20),),
                                  child: Container(
                                    height: responsiveheight(42),
                                    child: TextField(
                                      onChanged: (value) {
                                        tel = value;
                                        setState(() {
                                          !Validator.number(tel)
                                              ? errTel = null
                                              : errTel =
                                          'Veuillez entrer un numero';
                                        });
                                      },
                                      textAlign: TextAlign.center,
                                      keyboardType:
                                      TextInputType.numberWithOptions(),
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'Montserrat',

                                        // decorationColor: Color(0XFFFFCC00),//Font color change
                                        //  backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Tel',
                                        hoverColor: Colors.black87,
                                        errorText: errTel,
                                        errorStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20.0),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0XFF3B466B),
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0XFF389490), //vert
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: responsiveheight(2.0),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: responsivewidth(20),),
                                  child: Container(
                                    height: responsiveheight(42),
                                    child: TextField(
                                      // obscureText: true,
                                      onChanged: (value) {
                                        setState(() {
                                          pwd = value;
                                          double strength =
                                          estimatePasswordStrength(pwd);

                                          if (strength < 0.3) {
                                            errPwd = 'Mot de passe faible';
                                          } else {
                                            errPwd = null;
                                          }
                                        });
                                      },
                                      textAlign: TextAlign.center,

                                      autocorrect: false,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'Montserrat',

                                        // decorationColor: Color(0XFFFFCC00),//Font color change
                                        //  backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Mot de passe',
                                        hoverColor: Colors.black87,
                                        errorText: errPwd,
                                        errorStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20.0),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0XFF3B466B),
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0XFF389490), //vert
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: responsiveheight(2.0),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: responsivewidth(20),),
                                  child: Container(
                                    height: responsiveheight(42),
                                    child: TextField(
                                      // obscureText: true,
                                        autocorrect: false,
                                        textAlign: TextAlign.center,
                                        onChanged: (value) {
                                          pw = value;
                                          match();
                                        },
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontFamily: 'Montserrat',

                                          // decorationColor: Color(0XFFFFCC00),//Font color change
                                          //  backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
                                        ),
                                        decoration: InputDecoration(
                                          labelText:
                                          'Confirmer le mot de passe',
                                          errorText: errPw,
                                          errorStyle: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0XFF3B466B),
                                                width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0XFF389490), //vert
                                                width: 2.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0)),
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Column(
                        //photos

                        children: <Widget>[
                          SizedBox(
                            height: responsiveheight(140),
                          ),
                          Center(
                            child: Container(
                              height: responsivewidth(100.0),
                              width: responsivewidth(100.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey[300],
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(
                                    responsiveradius(20, 100)),
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.grey[200],
                                    blurRadius: responsiveradius(20.0, 100),
                                  ),
                                ],
                              ),
                              child: photoWig(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: responsiveheight(310),
                      left: responsivewidth(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: responsivewidth(20),
                                vertical: responsiveheight(20)),
                            child: Material(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(30.0)),
                              elevation: 5.0,
                              child: MaterialButton(
                                minWidth: responsivewidth(140),
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
                                      _registerWithGoogle();
                                    }
                                  } on SocketException catch (_) {
                                    _showSnackBar(
                                        'Vérifiez votre connexion internet');
                                  }
                                },
                                height: responsiveheight(42),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        height: responsiveheight(42),
                                        child: Image.asset(
                                            'images/googlelogo.png',
                                            fit: BoxFit.fill)),
                                    Text(
                                      'Google',
                                      style: TextStyle(
                                        color: Color(0XFF707070),
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Material(
                              color: Color(0XFF389490), //vert
                              borderRadius:
                              BorderRadius.all(Radius.circular(30.0)),
                              elevation: 5.0,
                              child: MaterialButton(
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
                                      _createUser();
                                    }
                                  } on SocketException catch (_) {
                                    _showSnackBar(
                                        'Vérifiez votre connexion internet');
                                  }
                                },
                                minWidth: responsivewidth(140.0),
                                height: responsiveheight(42.0),
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
                        ],
                      ),
                    ),
                    Positioned(
                      top: responsiveheight(120),
                      left: (MediaQuery
                          .of(context)
                          .size
                          .width * 0.5) -
                          responsivewidth(47) * 0.5 +
                          responsiveheight(100) * 0.5,
                      // left: responsivewidth(203),
                      child: Container(
                        //padding: EdgeInsets.all(1),
                        width: responsivewidth(47),
                        height: responsivewidth(47),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            // border: Border.all(color: secondarycolor, width: 1),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: secondarycolor,
                                  //Color.fromRGBO(59, 70, 107, 0.3),
                                  blurRadius: 3.0,
                                  //offset: Offset(0.0, 0.75),
                                  offset: Offset(responsivewidth(0.0),
                                      responsiveheight(0.75))),
                            ],
                            borderRadius: BorderRadius.circular(
                                responsiveradius(50, 1))),
                        child: Padding(
                          padding: EdgeInsets.all(responsivewidth(0.1)),
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              size: responsivewidth(30),
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
                                  showAlertDialog(
                                      context,
                                      "choisissez la source de l'image",
                                      "Source");
                                }
                              } on SocketException catch (_) {
                                _showSnackBar(
                                    'Vérifiez votre connexion internet');
                              }
                            },
                            // uploadFile();

                          ),
                        ),
                      ),
                    ),


                    SizedBox(
                      height: responsiveheight(50),
                    ),
                    Positioned(
                      left: SizeConfig.screenWidth * 0.5 - responsivewidth(70),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //  crossAxisAlignment:CrossAxisAlignment.center ,
                        children: <Widget>[
                          Container(
                            height: responsivewidth(60.0),
                            width: responsivewidth(60.0),
                            child: Image.asset(
                              'images/logo.png',
                              fit: BoxFit.fill,
                              height: responsivewidth(120.0),
                              width: responsivewidth(120.0),
                            ),
                          ),
                          Text(
                            'Winek',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 15.0,
                              fontWeight: FontWeight.w900,
                              color: Color(0XFF3B466B),
                            ),
                          ),
                          Text(
                            'Inscription',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: responsivetext(25.0),
                              fontWeight: FontWeight.w900,
                              color: Color(0XFF389490), //vert
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget photoWig() {
    if (_uploadedFileURL != null) {
      return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17.0),
            child: Image.network(
              _uploadedFileURL,
              height: 100.0,
              gaplessPlayback: true,
              fit: BoxFit.fill,
            ),
          ));
    } else {
      return Center(
          child: SpinKitChasingDots(
            color: Colors.deepPurpleAccent,
          ));
      /*ListView( //photos
            children: <Widget>[
              SizedBox(
                height: 16,),
              Icon(
                Icons.person,
                color: Color(0xFF5B5050),
                size: 105.0,
              ),
            ],),);*/
    }
  }

  bool loading = false;

  Future<String> _registerWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser =
      await authService.googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user =
          (await authService.auth.signInWithCredential(credential)).user;

      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await authService.auth.currentUser();
      assert(user.uid == currentUser.uid);
      Geoflutterfire geo = Geoflutterfire();
      LatLng lt = new LatLng(36.7525000, 3.0419700);
      GeoFirePoint pt =
      geo.point(latitude: lt.latitude, longitude: lt.longitude);
      print(currentUser.email);
      if (user != null) {
        var pic =
            "https://images.unsplash.com/photo-1485873295351-019c5bf8bd2e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80";
        if (googleUser.photoUrl.isNotEmpty) {
          pic = googleUser.photoUrl;
        }
        Utilisateur myUser = Utilisateur(
          pseudo: googleUser.displayName,
          mail: googleUser.email,
          //tel: null,
          favoris: [],
          photo: pic,
          amis: [],
          invitation: [],
          alertLIST: [],
          connecte: true,
          location: pt.data,
        );
        // authService.db.collection('Utilisateur').add(myUser.map);
        //authService..add(myUser.map);
        authService.db
            .collection('Utilisateur')
            .document(user.uid)
            .setData(myUser.map);
        print('user CREAAAATEEEEED');
        authService.getUserLocation();
        Provider.of<DeviceInformationService>(context, listen: false)
            .broadcastBatteryLevel(user.uid);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProfileScreen(myUser)));
      } else {
        print('failed google authetication');
      }
    } catch (e) {
      print(e);
    }
  }

  showSnackBar(String value, BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(SnackBar(
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
    ));
  }

  Future _createUser() async {
    try {
      setState(() {
        loading = true;
      });
      print('creaaation bdaaat ');
      Geoflutterfire geo = Geoflutterfire();
      LatLng lt = new LatLng(36.7525000, 3.0419700);
      GeoFirePoint pt =
      geo.point(latitude: lt.latitude, longitude: lt.longitude);
      final newUser = await authService.auth
          .createUserWithEmailAndPassword(email: email, password: pwd);
      if (newUser != null) {
        Utilisateur myUser = Utilisateur(
          pseudo: pseudo,
          mail: email,
          tel: tel,
          favoris: [],
          photo: _uploadedFileURL,
          amis: [],
          invitation: [],
          alertLIST: [],
          connecte: true,
          location: pt.data,
        );
        // authService.db.collection('Utilisateur').add(myUser.map);
        //authService..add(myUser.map);
        authService.db
            .collection('Utilisateur')
            .document(newUser.user.uid)
            .setData(myUser.map);
        print('user CREAAAATEEEEED');
        print(newUser.user.uid);
        authService.getUserLocation();
        Provider.of<DeviceInformationService>(context, listen: false)
            .broadcastBatteryLevel(newUser.user.uid);
        Navigator.pushNamed(context, Home.id);

        //  authService.db.collection(pseudo).add(myUser.map);
      } else {
        print('pas de creaaaation');
        setState(() {
          loading = false;
        });
      }
    } catch (signUpError) {
      if (signUpError is PlatformException) {
        if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          showSnackBar('Cet email est deja utilise', context);
        }
        if (signUpError.code == 'ERROR_INVALID_EMAIL') {
          showSnackBar("Veuillez introduire une adresse valide", context);
        }
        if (signUpError.code == 'ERROR_WEAK_PASSWORD') {
          showSnackBar('Mot de passe faible', context);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  String errTel;

  String errPwd, errMl, errPs, errPw;
  void match() {
    setState(() {
      if (pw != pwd) {
        errPw = 'Veuillez introduire le meme mot de passe';
      } else {
        errPw = null;
      }
    });
  }

  Future chooseFile(ImageSource source) async {
    File cropped;
    print('choooose file');
    _image = await ImagePicker.pickImage(source: source);

    if (_image != null) {
      cropped = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxHeight: 110,
        maxWidth: 110,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Rogner',
            toolbarColor: Color(0XFF389490), //vert
            statusBarColor: Colors.white,
            backgroundColor: Colors.white),
      );
    }
    if (cropped != null) {
      setState(() {
        _image = cropped;
      });
    }
    print('uploaaaaaaaaaadfile');
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('photos/${p.basename(_image.path)}}');
    _uploadedFileURL =
    "https://images.unsplash.com/photo-1485873295351-019c5bf8bd2e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80";

    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  pseudoExist() async {
    final QuerySnapshot result = await Future.value(authService.db
        .collection('Utilisateur')
        .where('pseudo', isEqualTo: pseudo)
        .limit(1)
        .getDocuments());
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 1) {
      print("UserName Already Exits");
      setState(() {
        errPs = 'Ce pseudo est deja pris';
      });
    } else {
      print("UserName is Available");
      setState(() {
        errPs = null;
      });
    }
  }

  mailExist() async {
    final QuerySnapshot result = await Future.value(authService.db
        .collection('Utilisateur')
        .where('pseudo', isEqualTo: email)
        .limit(1)
        .getDocuments());
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 1) {
      print("UserName Already Exits");
      setState(() {
        errMl = 'Ce pseudo est deja pris';
      });
    } else {
      print("UserName is Available");
      setState(() {
        errMl = null;
      });
    }
  }

  showAlertDialog(BuildContext context, String message, String heading) {
    // set up the buttons
    Widget GalleryButton = FlatButton(
      color: Color(0XFF389490),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(
            color: Color(0XFF389490),
            //vert
          )),
      child: Text(
        'Gallerie',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        chooseFile(ImageSource.gallery);
      },
    );
    Widget CameraButton = FlatButton(
      color: Color(0XFF3B466B),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(
            color: Color(0XFF3B466B),
//vert
          )),
      child: Text(
        'Camera',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        chooseFile(ImageSource.camera);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(heading),
      content: Text(message),
      backgroundColor: Colors.white,
      shape:
      RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
      actions: [
        GalleryButton,
        CameraButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
