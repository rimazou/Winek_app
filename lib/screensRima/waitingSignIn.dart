import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:winek/auth.dart';
import 'package:winek/screensHiba/MapPage.dart';
import 'package:winek/screensRima/welcome_screen.dart';

class SignInWait extends StatefulWidget {
  @override
  _SignInWaitState createState() => _SignInWaitState();
  static String id = 'waitSignIn';
}

class _SignInWaitState extends State<SignInWait> {
  @override
  void initState() {
    super.initState();
    _signOut();
  }

  _signOut() async {
    print(' debutsignout');
    /*print(authService.connectedID());
     authService.connectedID()!=null? print('theres is a user connected') : print ('pas de uuser ') ;
print('avant singnout');
    authService.auth.signOut();
    print('apres signout');
    authService.connectedID()!='noUser'? print('theres is a user connected') : print ('pas de uuser ') ;

     // authService.googleSignIn.signOut();*/

    await authService.connectedID().then((val) {
      print(val);
      authService.auth.signOut();
      authService.userRef.document(val).updateData({'connecte': false});
      print('plus d user');
    }).catchError((onError) {
      print('an error occured ');
    });
    print(' fin signout');
    Navigator.pushNamed(context, Home.id);

    // await authService.userRef.document('').updateData({'connecte':false}) ;
    /*authService.auth.signOut().then((onValue) {
      print(authService.isLog());
      authService.connectedID() != null
          ? print('theres is a user connected')
          : print('pas de uuser ');
    });*/
    //  authService.connectedID()!=null? print('theres is a user connected') : print ('pas de uuser ') ;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: SpinKitChasingDots(
              color: Color(0XFF389490),
            ),
          ),
        ),
      ),
    );
  }
}
