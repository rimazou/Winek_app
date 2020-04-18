import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../classes.dart';
import '../main.dart';

/*
class FriendsList extends StatefulWidget {
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  @override
  Widget build(BuildContext context) {
    final friends = Provider.of<List<Utilisateur>>(context);
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
        return FriendTile(user: friends[index]);
      },
    );
  }
}
*/
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
    final users = Provider.of<List<Utilisateur>>(context);
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
            ? new FriendTile(user: users[index])
            : users[index].pseudo.contains(widget.filter)
                ? new FriendTile(user: users[index])
                : new Container();
      },
    );
  }
}

class FriendTile extends StatelessWidget {
  final Utilisateur user;

  FriendTile({this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          user.pseudo,
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
            //go to that groupe info page
          },
          icon: Icon(Icons.info_outline),
          color: Color(0xff389490),
          iconSize: 30,
        ),
      ),
    );
  }
}

/*
ListView.builder(
itemCount: user.amis.length,
itemBuilder: (context, index) {
return Card(
child: ListTile(
onTap: () {
setState(() {
membres.contains(user.amis[index])
? membres.remove(user.amis[index])
    : membres.add(user.amis[index]);
});
},
title: Text(
user.amis[index].pseudo,
style: TextStyle(
fontSize: 14,
fontFamily: 'Montserrat',
fontWeight: FontWeight.w600,
color: Color(0xff707070),
),
),
leading: Icon(
Icons.person,
color: primarycolor,
size: 30,
),
trailing: membres.contains(user.amis[index])
? Icon(
Icons.done,
color: secondarycolor,
size: 30,
)
    : Icon(
Icons.add_circle_outline,
color: secondarycolor,
size: 30,
),
),
);
}),*/
