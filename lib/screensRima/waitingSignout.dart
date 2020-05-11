import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:winek/auth.dart';
import 'package:winek/screensRima/login_screen.dart';
import 'package:winek/screensRima/welcome_screen.dart';

class SignoutWait extends StatefulWidget {
  @override
  _SignoutWaitState createState() => _SignoutWaitState();
  static String id = 'waitSignout';
}

class _SignoutWaitState extends State<SignoutWait> {
  @override
  void initState() {
    super.initState();
    _signOut();
  }

  _signOut() async {
    print(' debutsignout');

    try {
      await authService.connectedID().then((val) {
        print(val);
        authService.auth.signOut();
        authService.userRef.document(val).updateData({'connecte': false});
        print('plus d user');
      }).catchError((onError) {
        print('an error occured ');
      });
      print(' fin signout');
      Navigator.pushNamed(context, LoginScreen.id);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: SpinKitChasingDots(
              color: Color(0xFF3B466B),
            ),
          ),
        ),
      ),
    );
  }
}
