import 'dart:core';
import 'dart:io';
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
                  height: 48.0,
                ),
                TextField(
                  onChanged: (value) {
                  //  setState(() {
                      pseudo= value;
                    /*  streamQuery = authService.userRef
                          .where('pseudo', isGreaterThanOrEqualTo: pseudo)
                          .where('pseudo', isLessThan: pseudo +'z')
                          .snapshots();
                      streamQuery.isEmpty==true ? errPs='null' : errPs="errooor"  ;

                    });*/
                    },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',

                    // decorationColor: Color(0XFFFFCC00),//Font color change
                    //  backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
                  ),
                  decoration: InputDecoration(
                    labelText: 'Pseudonyme',

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
                  onChanged: (value) {
                    email = value;
                    setState(() {

                    !Validator.email(email) ? errMl=null :errMl='Veuillez entrer un email';
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
                    labelText: 'Email',
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

                    if (strength < 0.3)
                      errPwd='Password too weak' ;
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
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    )


                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () => _createUser(),
                      minWidth: 200.0,
                      height: 42.0,
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
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
      final newUser = await authService.auth.createUserWithEmailAndPassword(
          email: email,
          password: pwd);
      if (newUser != null) {
        Utilisateur myUser = Utilisateur(
            pseudo: pseudo,
            mail: email,
            mdp: pwd,
            tel: tel,

          photo:"https://images.unsplash.com/photo-1485873295351-019c5bf8bd2e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
//p.basename(_uploadedFileURL),
          amis: <String>[] ,
          invitation: [],
          invitationGroupe: [],
          connecte: true,
        );
        authService.db.collection('Utilisateur').add(myUser.map);
         //authService..add(myUser.map);
         print('user CREAAAATEEEEED');
        Navigator.pushNamed(context, ProfileScreen.id);

        //  authService.db.collection(pseudo).add(myUser.map);
      }else {
        print ('pas de creaaaation');
      }
    }
    catch (signUpError) {setState(() {

      if (signUpError is  PlatformException  ) {
        if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          errMl='ERROR_EMAIL_ALREADY_IN_USE';
        }else{
          errMl=null ;

        }
          if (signUpError.code == 'ERROR_INVALID_EMAIL')
          {
            errMl='ERROR_INVALID_EMAIL';

          }else {
            errMl=null ;

          }
            if (signUpError.code == 'ERROR_WEAK_PASSWORD')
            {
              errPwd='ERROR_WEAK_PASSWORD';

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
         errPwd='Veuillez introduire le meme mot de passe ';
      } else {
        errPwd=null;
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
  }
  Future uploadFile() async {
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

  void clearSelection() {
    setState(() {
      _image=null ;
    });
  }
Stream    streamQuery ;


  }


