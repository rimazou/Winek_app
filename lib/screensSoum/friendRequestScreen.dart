import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winek/screensSoum/friendRequestList.dart';

import '../dataBaseSoum.dart';

class FriendRequestListScreen extends StatefulWidget {
  static String id = 'FriendRequestListScreen';
  String current;

  FriendRequestListScreen(this.current);

  @override
  _FriendRequestListScreenState createState() =>
      _FriendRequestListScreenState(current);
}

class _FriendRequestListScreenState extends State<FriendRequestListScreen> {

  String current;

  _FriendRequestListScreenState(this.current);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<String>>.value(
      value: Database(current: this.current).friendRequest,
      child: Scaffold(
        backgroundColor: Colors.white,
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
