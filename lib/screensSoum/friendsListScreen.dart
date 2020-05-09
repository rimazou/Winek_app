import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winek/screensSoum/friendsList.dart';

import '../dataBaseSoum.dart';
import 'usersListScreen.dart';
import 'friendRequestScreen.dart';
import 'package:winek/auth.dart';

var _controller = TextEditingController();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class FriendsListScreen extends StatefulWidget {
  static const String id = 'FriendsListScreen';
  String current;

  FriendsListScreen(this.current);


  @override
  _FriendsListScreenState createState() => _FriendsListScreenState(current);
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  static const String id = '_FriendsListScreenState';
  Database d;

  String current;

  _FriendsListScreenState(this.current);

  Future<Database> init() async {
    Database da = await Database().init();
    return da;
  }


  @override
  Widget build(BuildContext context) {
    init().then((Database result) {
      this.d = result;

      print(d);
    });

    _showSnackBar(String value ) {
      final snackBar = new SnackBar(
        content: new  Text(
          value,
          style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600),
        ),
        duration: new Duration(seconds: 2),
        //backgroundColor: Colors.green,
        action: new SnackBarAction(label: 'Ok', onPressed: (){
          print('press Ok on SnackBar');
        }),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }

    return StreamProvider<List<dynamic>>.value(
      value: Database(current: this.current).friends,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white30,
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Colors.black54,
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () async {
                    try {
                    final result = await InternetAddress.lookup('google.com');
                    var result2 = await Connectivity().checkConnectivity();
                    var b = (result2 != ConnectivityResult.none);

                    if (b && result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  String currentUser = await AuthService().connectedID();
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          FriendRequestListScreen(currentUser)));

                    } }   on SocketException catch (_) {
                      _showSnackBar('Vérifiez votre connexion internet');
                    }
                },
                icon: Icon(Icons.group_add),
                color: Color(0xFF3B466B),
                iconSize: 35.0,
              ),
            ],
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                ),
                Center(
                  child: Text(
                    'Liste d\'amis',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF389490),
                      fontFamily: 'Montserrat-Bold',
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Container(
                  height: 420.0,
                  width: 350.0,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFD0D8E2),
                  ),
                  child: FriendsList(),
                ),
                Spacer(flex: 1),
                Container(
                  height: 38,
                  width: 155,
                  decoration: BoxDecoration(
                    color: Color(0xff389490),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, UsersListScreen.id);
                    },
                    child: FlatButton(
                      child: Center(
                        child: Text(
                          'Rechercher',
                          style: TextStyle(
                            fontFamily: 'montserrat',
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(
                  flex: 1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
