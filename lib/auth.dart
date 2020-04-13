import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart';
import 'classes.dart';
class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance ;
  final Firestore _db =Firestore.instance ;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']) ;
FirebaseUser _loggedIn ;
get userRef => _db.collection('Utilisateur');

  FirebaseUser get loggedIn => _loggedIn;

  /* _signInG() async {
    try{
      await _googleSignIn.signIn();
      GoogleSignInAccount googleUser = await _googleSignIn.signIn() ;
      GoogleSignInAuthentication googleAuth = await googleUser.authentication ;
      FirebaseUser user = await _auth.signInWithGoogle(
        accessToken
      )
      setState(() {
        _isLoggedin=true ;
        print('vous etes connecte');
      })
    }
    catch(err){
      print(err);
    };*/ //on doit avoir stateful widget

   /* _signOutG() async {
      try{
        await _googleSignIn.signOut();

      }
      catch(err){
        print(err);
      }
  }
*/
  GoogleSignIn get googleSignIn => _googleSignIn;

  Firestore get db => _db;

  FirebaseAuth get auth => _auth;

  set loggedIn(FirebaseUser value) {
    _loggedIn = value;
  }

  Utilisateur toUtil ()
{
  loggedIn = auth.currentUser() as FirebaseUser ;
  return Utilisateur(
    pseudo: loggedIn.uid ,
    tel: loggedIn.phoneNumber,
    mail: loggedIn.email ,

  ) ;
}

Future sendPwdResetEmail ( String email) async
{
  try {
final reset =  _auth.sendPasswordResetEmail(email: email) ;
}
catch(e)
  {
    print(e) ;
  }
}
  Future<bool> isUserLogged() async {
    FirebaseUser firebaseUser = await getLoggedFirebaseUser();
    if (firebaseUser != null) {
      IdTokenResult tokenResult = await firebaseUser.getIdToken(refresh: true);
      return tokenResult.token != null;
    } else {
      return false;
    }
  }

  Future<FirebaseUser> getLoggedFirebaseUser() {
    return auth.currentUser();
  }


}

final  AuthService authService = AuthService();
