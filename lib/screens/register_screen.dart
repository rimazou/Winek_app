import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:winek/auth.dart';
import 'package:winek/classes.dart';
import 'package:winek/screens/profile_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:password_strength/password_strength.dart';
import 'package:path/path.dart' as p ;
class RegistrationScreen extends StatefulWidget {
  static const String id='register';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email, pw, pwd, pseudo, tel;
  File _image;
  String _uploadedFileURL;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[

                SizedBox(
                  height: 30.0,
                ),

                Container(

                  height: 60.0,
                  width: 60.0,
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
                  'Inscription',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 42.0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child :CircleAvatar(
                        radius: 40,
                        child: ClipOval(
                          child: SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child:(_image!=null) ? Image.file(_image,fit: BoxFit.fill,)
                                : Image.network(
                              "https://images.unsplash.com/photo-1485873295351-019c5bf8bd2e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          size: 30.0,),
                        onPressed: () => chooseFile(),
                        // uploadFile();

                      ),
                    )
                  ],
                ),
                TextField(
                  onChanged: (value) {
                      pseudo= value;
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
                    keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                    setState(() {

                    !Validator.email(email) ? errMl=null : errMl="Veuillez introduire une adresse valide";
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
                    tel = value;
                    setState(() {

                    !Validator.number(tel) ? errTel=null :  errTel='Veuillez entrer un numero';
    });

  },
                  textAlign: TextAlign.center,

                  keyboardType: TextInputType.numberWithOptions(

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
                  // obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      pwd = value;
                 double strength = estimatePasswordStrength(pwd);

                    if (strength < 0.3) { errPwd='Mot de passe faible' ;}
                    else {
                      errPwd=null ;
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
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    )


                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: Color(0XFF389490),//vert
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(

                      onPressed: () => _createUser(),
                      minWidth: 200.0,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _createUser() async {
    try {
      print('creaaation bdaaat ');
      Geoflutterfire geo = Geoflutterfire();
      LatLng lt = new LatLng(36.7525000, 3.0419700);
      final newUser = await authService.auth.createUserWithEmailAndPassword(
          email: email,
          password: pwd);
      if (newUser != null) {
        Utilisateur myUser = Utilisateur(
            pseudo: pseudo,
            mail: email,
            tel: tel,

          photo:_uploadedFileURL ,
          amis: <String>[] ,
          invitation: [],
          invitation_groupe: [],
          alertLIST: [],
          connecte: true,
          // location: geo.point(latitude: lt.latitude ,longitude: lt.longitude) ,
        );
        // authService.db.collection('Utilisateur').add(myUser.map);
         //authService..add(myUser.map);
        authService.db.collection('Utilisateur').document('AAAAA').setData(
            myUser.map);
         print('user CREAAAATEEEEED');
        print(newUser.user.uid);
        Navigator.pushNamed(context, ProfileScreen.id);

        //  authService.db.collection(pseudo).add(myUser.map);
      }else {
        print ('pas de creaaaation');
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
  Future chooseFile() async {
    print('choooose file') ;
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
    print('uploaaaaaaaaaadfile') ;
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('photos/${p.basename(_image.path)}}');
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


  }


