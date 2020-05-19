import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:winek/screensSoum/profile.dart';
import 'package:provider/provider.dart';
import '../classes.dart';
import 'package:winek/dataBaseSoum.dart';
import 'package:winek/auth.dart';
import 'dart:io';
import 'dart:ui';

class FriendsList extends StatefulWidget {
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  @override
  Widget build(BuildContext context) {
    final friends = Provider.of<List<dynamic>>(context);
    int count;
    if (friends != null) {
      count = friends.length;
    } else {
      count = 0;
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (context, index) {
        return FriendTile(id: friends[index]);
      },
    );
  }
}

class FriendTile extends StatefulWidget {
  Map id;
  String image;

  FriendTile({Map id}) {
    this.id = id;
  }

  @override
  _FriendTileState createState() => _FriendTileState(id: id);
}

class _FriendTileState extends State<FriendTile> {
  String image;

  Map id;

  _FriendTileState({Map id}) {
    this.id = id;
    Firestore.instance
        .collection('Utilisateur')
        .where("pseudo", isEqualTo: id['pseudo'])
        .limit(1)
        .snapshots()
        .listen((data) {
      if (data != null) {
        for (var doc in data.documents) {
          // data.documents.forEach((doc) {
          if (mounted) {
            setState(() {
              image = doc.data['photo'];
            });
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget photo() {
    if (image != null) {
      return CircleAvatar(
        radius: 23.0,
        backgroundImage: NetworkImage(image),
        backgroundColor: Colors.transparent,
      );
    } else {
      return Icon(
        Icons.people,
        color: Color(0xff3B466B),
        size: 32,
      );
    }
  }

  _showSnackBar(String value, BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(SnackBar(
      content: new Text(
        value,
        style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600),
      ),
      duration: new Duration(seconds: 2),
      //backgroundColor: Colors.green,
      action: new SnackBarAction(
          label: 'Ok',
          onPressed: () {
            print('press Ok on SnackBar');
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          id['pseudo'],
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Color(0xff707070),
          ),
        ),
        leading: photo(),
        trailing: IconButton(
          onPressed: () async {
            try {
              final result = await InternetAddress.lookup('google.com');
              var result2 = await Connectivity().checkConnectivity();
              var b = (result2 != ConnectivityResult.none);

              if (b && result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                String currentUser = await authService.connectedID();
                if (currentUser != null) {
                  String name = await Database().getPseudo(currentUser);
                  //go to the profile screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen2(
                              friend: id,
                              currentUser: currentUser,
                              name: name,
                            )),
                  );
                }
              }
            } on SocketException catch (_) {
              _showSnackBar('Vérifiez votre connexion internet', context);
            }
          }, // call the class and passing arguments

          icon: Icon(Icons.info_outline),
          color: Color(0xff389490),
          iconSize: 30,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class UsersList extends StatefulWidget {
  String filter;

  UsersList(this.filter);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<String>>(context);
    int count;
    if (users != null) {
      count = users.length;
    } else {
      count = 0;
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (context, index) {
        return widget.filter == null || widget.filter == ""
            ? new UserTile(id: users[index])
            : users[index].toString().contains(widget.filter)
                ? new UserTile(id: users[index])
                : new Container();
      },
    );
  }
}

class UserTile extends StatefulWidget {
  String id;

  UserTile({this.id});

  @override
  _UserTileState createState() => _UserTileState(id: id);
}

class _UserTileState extends State<UserTile> {
  String image;

  String id;

  bool tap;

  _UserTileState({String id}) {
    this.id = id;

    Firestore.instance
        .collection('Utilisateur')
        .where("pseudo", isEqualTo: id)
        .limit(1)
        .snapshots()
        .listen((data) {
      for (var doc in data.documents) {
        // data.documents.forEach((doc) {
        if (mounted) {
          setState(() {
            image = doc.data['photo'];
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget photo() {
    if (image != null) {
      return CircleAvatar(
        radius: 23.0,
        backgroundImage: NetworkImage(image),
        backgroundColor: Colors.transparent,
      );
    } else {
      return Icon(
        Icons.people,
        color: Color(0xff3B466B),
        size: 32,
      );
    }
  }

  _showSnackBar(String value, BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(SnackBar(
      content: new Text(
        value,
        style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600),
      ),
      duration: new Duration(seconds: 2),
      //backgroundColor: Colors.green,
      action: new SnackBarAction(
          label: 'Ok',
          onPressed: () {
            print('press Ok on SnackBar');
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          widget.id,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Color(0xff707070),
          ),
        ),
        leading: photo(),
        trailing: IconButton(
          onPressed: () async {
            try {
              final result = await InternetAddress.lookup('google.com');
              var result2 = await Connectivity().checkConnectivity();
              var b = (result2 != ConnectivityResult.none);

              if (b && result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                String currentUser = await authService.connectedID();
                if (currentUser != null) {
                  String name = await Database().getPseudo(currentUser);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen2(
                              pseudo: widget.id,
                              currentUser: currentUser,
                              name: name,
                            )),
                  ); // call the class and passing arguments
                }
              }
            } on SocketException catch (_) {
              _showSnackBar('Vérifiez votre connexion internet', context);
            }
          },
          icon: Icon(Icons.info_outline),
          color: Color(0xff389490),
          iconSize: 30,
        ),
      ),
    );
  }
}
