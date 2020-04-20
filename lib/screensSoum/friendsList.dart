import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:winek/screensSoum/profile.dart';
import 'package:provider/provider.dart';
import '../classes.dart';
import 'package:winek/dataBaseSoum.dart';

class FriendsList extends StatefulWidget {
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  @override
  Widget build(BuildContext context) {
    final friends = Provider.of<List<String>>(context);
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

class FriendTile extends StatelessWidget {
  final String id;

  FriendTile({this.id});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          Database().getPseudo(id),
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Color(0xff707070),
          ),
        ),
        leading: Icon(
          Icons.people,
          color: Color(0xff3B466B),
          size: 30,
        ),
        trailing: IconButton(
          onPressed: () {
            //go to the profile screen
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen2(id, Database.currentUser)),
            ); // call the class and passing arguments
          },
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
            : Database().getPseudo(users[index]).contains(widget.filter)
                ? new UserTile(id: users[index])
                : new Container();
      },
    );
  }
}

class UserTile extends StatelessWidget {
  final String id;

  UserTile({this.id});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          Database().getPseudo(id),
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Color(0xff707070),
          ),
        ),
        leading: Icon(
          Icons.people,
          color: Color(0xff3B466B),
          size: 30,
        ),
        trailing: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen2(id, Database.currentUser)),
            ); // call the class and passing arguments
          },
          icon: Icon(Icons.info_outline),
          color: Color(0xff389490),
          iconSize: 30,
        ),
      ),
    );
  }
}
