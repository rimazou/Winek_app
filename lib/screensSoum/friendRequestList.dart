import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class FriendRequestTile extends StatelessWidget {
  final String invit;

  FriendRequestTile({this.invit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          invit,
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              onPressed: () async {
                Database d= await Database().init(pseudo: invit , subipseudo: Database.currentName);
                await d.userUpdateData();
                Database c =await Database().init( pseudo:  Database.currentName , subipseudo: invit );
                await c.userUpdateData();
                await Database( pseudo: invit).userDeleteData(Database.currentUser);
              },
              icon: Icon(Icons.check),
              color: Color(0xFF389490),
              iconSize: 25,
            ),
            IconButton(
              onPressed: () async {
                await Database( pseudo: invit).userDeleteData(Database.currentUser);
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
