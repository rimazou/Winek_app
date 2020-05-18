import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:winek/auth.dart';
import 'package:winek/screensHiba/MapPage.dart';
import 'package:winek/screensRima/login_screen.dart';

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

    try {
      await authService.connectedID().then((val) {
        authService.auth.signOut();
        authService.userRef.document(val).updateData({'connecte': false});
      });
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    } catch (e) {
      Navigator.pushReplacementNamed(context, Home.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
