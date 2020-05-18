import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:winek/screensHiba/MapPage.dart';
import 'package:winek/screensRima/login_screen.dart';
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

        authService.getUserLocation();
        authService.updategroupelocation();
        Provider.of<DeviceInformationService>(context, listen: false)
            .broadcastBatteryLevel(id);
        Navigator.pushReplacementNamed(context, Home.id);
      } else {

        Navigator.pushReplacementNamed(
            context, LoginScreen.id);

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
