import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:winek/screensHiba/MapPage.dart';
import 'package:winek/screensRima/welcome_screen.dart';

import '../auth.dart';

class FirstLoading extends StatefulWidget {
  static const String id = 'firstloa';

  @override
  _FirstLoadingState createState() => _FirstLoadingState();
}

class _FirstLoadingState extends State<FirstLoading> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  void navigate() async {
    await authService.isLog().then((log) {
      if (log) {
        print('yes log');
        Navigator.pushNamed(context, Home.id);
      } else {
        print('no log');
        Navigator.pushNamed(context, WelcomeScreen.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
