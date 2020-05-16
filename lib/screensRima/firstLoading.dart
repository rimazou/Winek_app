import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:winek/screensHiba/MapPage.dart';
import 'package:winek/screensRima/welcome_screen.dart';
import 'package:winek/UpdateMarkers.dart';
import 'package:provider/provider.dart';
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
    await authService.isLog().then((log) async {
      if (log) {
        String id = await authService.connectedID();

        print('yes log');
        authService.getUserLocation();
        authService.updategroupelocation();
        Provider.of<DeviceInformationService>(context, listen: false)
            .broadcastBatteryLevel(id);
        Navigator.pushNamed(context, Home.id);
      } else {
        print('no log');
        Navigator.pushNamed(
            context, WelcomeScreen.id); // va devenir apres loginscreen

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
              color: Color(0XFF389490),
            ),
          ),
        ),
      ),
    );
  }
}
