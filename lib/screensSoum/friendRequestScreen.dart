import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winek/screensSoum/friendRequestList.dart';

import '../dataBaseSoum.dart';

class FriendRequestListScreen extends StatelessWidget {
  static String id = 'FriendRequestListScreen';

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<String>>.value(
      value: Database().friendRequest,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white30,
          elevation: 0.0,
          iconTheme: IconThemeData(
            size: 50.0,
            color: Colors.black54,
          ),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
              ),
              Center(
                child: Text(
                  'Liste d\'invitaions',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF389490),
                    fontFamily: 'Montserrat-Bold',
                  ),
                ),
              ),
              Spacer(flex: 2),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFD0D8E2),
                ),
                padding: EdgeInsets.all(10.0),
                height: 460.0,
                width: 350.0,
                child: FriendRequestsList(),
              ),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
