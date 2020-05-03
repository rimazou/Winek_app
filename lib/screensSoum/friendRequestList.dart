import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winek/auth.dart';

import '../dataBaseSoum.dart';

class FriendRequestsList extends StatefulWidget {
  @override
  _FriendRequestsListState createState() => _FriendRequestsListState();
}

class _FriendRequestsListState extends State<FriendRequestsList> {
  @override
  Widget build(BuildContext context) {
    final friendRequest = Provider.of<List<String>>(context);
    int count;
    if (friendRequest != null) {
      count = friendRequest.length;
    } else {
      count = 0;
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (context, index) {
        return FriendRequestTile(invit: friendRequest[index]);
      },
    );
  }
}

class FriendRequestTile extends StatefulWidget {
  String invit;

  FriendRequestTile({this.invit});

  @override
  _FriendRequestTileState createState() =>
      _FriendRequestTileState(invit: invit);
}

class _FriendRequestTileState extends State<FriendRequestTile> {
  String invit;
  String image;


  _FriendRequestTileState({String invit}) {
    this.invit = invit;
    print('constructooooooooooor');
    Firestore.instance
        .collection('Utilisateur')
        .where("pseudo", isEqualTo: invit)
        .limit(1)
        .snapshots()
        .listen((data) {
      data.documents.forEach((doc) {
        setState(() {
          print('inviiiiiiiiiit tof');
          image = doc.data['photo'];
          print(image);
        });
      }
      );
    });
  }


  @override
  void initState() {
    super.initState();
  }

  Widget photo() {

    if (image != null) {
      print('photoooos');
      return CircleAvatar(
        radius: 23.0,
        backgroundImage: NetworkImage(image),
        backgroundColor: Colors.transparent,
      );

    }
    else {
      print('noooo photoooos');
      return Icon(
        Icons.people,
        color: Color(0xff3B466B),
        size: 32,

      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async {
          String currentUser = await AuthService().connectedID();
          String name = await Database().getPseudo(currentUser);
          print('bouuuuutttooooooooooon current user $currentUser');
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen2(pseudo: widget.invit,
                      currentUser: currentUser,
                      name: name,)),);
        },
        title: Text(
          widget.invit,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Color(0xff707070),
          ),
        ),
        leading: photo(),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              onPressed: () async {
                String currentUser = await AuthService().connectedID();
                String name = await Database().getPseudo(currentUser);
                Database d = await Database().init(
                    pseudo: widget.invit, subipseudo: name);
                await d.userUpdateData();
                Database c = await Database().init(
                    id: currentUser, subipseudo: widget.invit);
                await c.userUpdateData();
                await Database(pseudo: widget.invit).userDeleteData(
                    currentUser);
              },
              icon: Icon(Icons.check),
              color: Color(0xFF389490),
              iconSize: 25,
            ),
            IconButton(
              onPressed: () async {
                String currentUser = await AuthService().connectedID();
                await Database(pseudo: widget.invit).userDeleteData(
                    currentUser);
              },
              icon: Icon(Icons.delete),
              color: Colors.red,
              iconSize: 25,
            ), // icon-2
          ],
        ),
      ),
    );
  }
}
