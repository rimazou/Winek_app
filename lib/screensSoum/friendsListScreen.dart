import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winek/screensSoum/friendsList.dart';

import '../dataBaseSoum.dart';
import 'usersListScreen.dart';
import 'friendRequestScreen.dart';
import 'package:winek/auth.dart';

var _controller = TextEditingController();

class FriendsListScreen extends StatelessWidget {
  static const String id = 'FriendsListScreen';

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<String>>.value(
      value: Database().friends,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
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
                  Navigator.pushNamed(context, FriendRequestListScreen.id);
                  //await AuthService().connectedID();
                },
                icon: Icon(Icons.group_add),
                color: Color(0xFF5B5050),
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
