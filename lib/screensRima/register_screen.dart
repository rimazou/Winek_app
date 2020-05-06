import 'dart:core';
import 'dart:io';
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
import 'package:winek/screensHiba/MapPage.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:password_strength/password_strength.dart';
import 'package:winek/UpdateMarkers.dart';
import 'package:path/path.dart' as p ;
class RegistrationScreen extends StatefulWidget {
  static const String id='register';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email,
      pw,
      pwd,
      pseudo,
      tel,
      pic = "https://images.unsplash.com/photo-1485873295351-019c5bf8bd2e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80";
  File _image;
  String _uploadedFileURL;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
          child: SpinKitChasingDots(
            color: Colors.deepPurpleAccent,
          )
      );
    } else {
      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(28.0),
            child: AppBar(
              backgroundColor: Colors.white30,
              elevation: 0.0,
              iconTheme: IconThemeData(
                color: Colors.black54,
              ),

            ),),
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
                            height: 140,
                          ),
                          Container(
                            height: 800.0,
                            width: 320.0,
                          ),
                        ],),
                    ),

                    Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 190,
                          ),
                          Container(
                            height: 400.0,
                            width: 320.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey[300],
                                width: 3,),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.grey[200],
                                  blurRadius: 20.0,),
                              ],
                              borderRadius: BorderRadius.circular(20),),
                            child: Column(
                              children: <Widget>[


                                SizedBox(
                                  height: 80.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Container(height: 38,
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
                                        contentPadding:
                                        EdgeInsets.symmetric(
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
                                  height: 8.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Container(height: 38,
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
                                        contentPadding:
                                        EdgeInsets.symmetric(
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
                                  height: 8.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Container(height: 38,
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

                                      keyboardType: TextInputType
                                          .numberWithOptions(

                                      ),
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
                                        contentPadding:
                                        EdgeInsets.symmetric(
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
                                  height: 8.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Container(
                                    height: 38,
                                    child: TextField(
                                      // obscureText: true,
                                      onChanged: (value) {
                                        setState(() {
                                          pwd = value;
                                          double strength = estimatePasswordStrength(
                                              pwd);

                                          if (strength < 0.3) {
                                            errPwd = 'Mot de passe faible';
                                          }
                                          else {
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
                                        contentPadding:
                                        EdgeInsets.symmetric(
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
                                  height: 8.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Container(
                                    height: 38,
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
                                        decoration:
                                        InputDecoration(
                                          labelText: 'Confirmer le mot de passe',
                                          errorText: errPw,
                                          errorStyle: TextStyle(
                                              fontFamily: 'Montserrat',

                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                          contentPadding:
                                          EdgeInsets.symmetric(
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
                                        )


                                    ),
                                  ),
                                ),

                              ],),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Column( //photos


                        children: <Widget>[
                          SizedBox(
                            height: 140,
                          ),

                          Center(
                            child: Container(
                              height: 100.0,
                              width: 100.0,

                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey[300],
                                  width: 3,),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.grey[200],
                                    blurRadius: 20.0,),
                                ],
                              ),
                              child: photoWig(),
                            ),
                          ),


                        ],

                      ),
                    ),
                    Positioned(
                      bottom: 317,
                      left: 25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Material(
                              color: Color(0XFF3B466B),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(30.0)),
                              elevation: 5.0,
                              child: MaterialButton(


                                onPressed: () => _registerWithGoogle(),
                                minWidth: 140.0,
                                height: 42.0,
                                child: Text(
                                  "Google",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,

                                  ),
                                ),
                              ),
                            ),
                          ),


                          SizedBox(
                            width: 30,
                          ),


                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Material(
                              color: Color(0XFF389490), //vert
                              borderRadius: BorderRadius.all(
                                  Radius.circular(30.0)),
                              elevation: 5.0,
                              child: MaterialButton(

                                onPressed: () => _createUser(),
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
                        ],
                      ),
                    ),
                    Positioned(
                      top: 130,
                      right: 113,
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.only(bottom: 0, right: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          color: Colors.white,),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 0, right: 3),
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              size: 30.0,),
                            onPressed: () =>
                                showAlertDialog(
                                    context, "choisissez la source de l'image",
                                    "Source"),
                            // uploadFile();

                          ),
                        ),
                      ),),
                    Positioned(
                      left: 157.5,
                      top: 50,
                      child: Text(
                        'Winek',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w900,
                          color: Color(0XFF3B466B),

                        ),
                      ),
                    ),

                    Positioned(
                      left: 96,
                      top: 70,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20,),
                        child: Text(
                          'Inscription',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0XFF389490), //vert
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),

                    Positioned(
                      left: 149,
                      child: Container(

                        height: 60.0,
                        width: 60.0,
                        child: Image.asset('images/logo.png', fit: BoxFit.fill,
                          height: 120.0,
                          width: 120.0,),
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

            child: Image.network(_uploadedFileURL,
              height: 100.0,

              gaplessPlayback: true,
              fit: BoxFit.fill,
            ),
          )
      );
    }
    else {
      return
        Center(
            child: SpinKitChasingDots(
              color: Colors.deepPurpleAccent,
            )
        );
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
      final GoogleSignInAccount googleUser = await authService.googleSignIn
          .signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user = (await authService.auth.signInWithCredential(
          credential)).user;

      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await authService.auth.currentUser();
      assert(user.uid == currentUser.uid);
      Geoflutterfire geo = Geoflutterfire();
      LatLng lt = new LatLng(36.7525000, 3.0419700);
      GeoFirePoint pt = geo.point(
          latitude: lt.latitude, longitude: lt.longitude);
      print(currentUser.email);
      if (user != null) {
        var pic = "https://images.unsplash.com/photo-1485873295351-019c5bf8bd2e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80";
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
        authService.db.collection('Utilisateur').document(user.uid).setData(
            myUser.map);
        print('user CREAAAATEEEEED');
        getUserLocation();
        Provider.of<DeviceInformationService>(context, listen: false)
            .broadcastBatteryLevel(user.uid);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) =>
                ProfileScreen(myUser)
        ));
      }
      else {
        print('failed google authetication');
      }
    }
    catch (e) {
      print(e);
    }
  }


  Future _createUser() async {
    try {
      setState(() {
        loading = true;
      });
      print('creaaation bdaaat ');
      Geoflutterfire geo = Geoflutterfire();
      LatLng lt = new LatLng(36.7525000, 3.0419700);
      GeoFirePoint pt = geo.point(latitude: lt.latitude, longitude: lt.longitude) ;
      final newUser = await authService.auth.createUserWithEmailAndPassword(
          email: email,
          password: pwd);
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
        authService.db.collection('Utilisateur').document(newUser.user.uid).setData(
            myUser.map);
        print('user CREAAAATEEEEED');
        print(newUser.user.uid);
        getUserLocation();
        Provider.of<DeviceInformationService>(context, listen: false)
            .broadcastBatteryLevel(newUser.user.uid);
        Navigator.pushNamed(context, Home.id);

        //  authService.db.collection(pseudo).add(myUser.map);
      }else {
        print ('pas de creaaaation');
        setState(() {
          loading = false;
        }
        );
      }
    }
    catch (signUpError) {setState(() {

      if (signUpError is  PlatformException  ) {
        if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          errMl='Cet email est deja utilise';
        }else{
          errMl=null ;

        }
        if (signUpError.code == 'ERROR_INVALID_EMAIL')
        {
          errMl="Veuillez introduire une adresse valide";

        }else {
          errMl=null ;

        }
        if (signUpError.code == 'ERROR_WEAK_PASSWORD')
        {
          errPwd='Mot de passe faible';

        }
        else {
          errPwd=null ;
        }
      }
    }   );
    }
    catch(e)
    {
      print(e);
    }

  }
  String errTel;

  String errPwd, errMl ,errPs, errPw ;
  void match() {
    setState(() {

      if (pw != pwd) {
        errPw='Veuillez introduire le meme mot de passe';
      } else {
        errPw=null;
      }
    });
  }

  Future chooseFile(ImageSource source) async {
    File cropped;
    print('choooose file') ;
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
    print('uploaaaaaaaaaadfile') ;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('photos/${p.basename(_image.path)}}');
    _uploadedFileURL="https://images.unsplash.com/photo-1485873295351-019c5bf8bd2e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80";

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
          side: BorderSide(color: Color(0XFF389490),
            //vert
          )
      ),
      child: Text('Gallerie', style: TextStyle(
        fontFamily: 'Montserrat',

        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),),
      onPressed: () {
        Navigator.pop(context);
        chooseFile(ImageSource.gallery);
      },
    );
    Widget CameraButton = FlatButton(
      color: Color(0XFF3B466B),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Color(0XFF3B466B),
//vert
          )
      ),
      child: Text('Camera', style: TextStyle(
        fontFamily: 'Montserrat',

        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),),
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


