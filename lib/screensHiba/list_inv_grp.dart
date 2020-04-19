import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../classes.dart';
import '../main.dart';
import 'package:winek/dataBasehiba.dart';

Future<List<Map<dynamic, dynamic>>> getListInvitations() async {
  Map user ={ 'pseudo': '' , 'id': ''};
  Database.getcurret(user['id'], user['pseudo']);

  DocumentSnapshot querySnapshot = await Firestore.instance
      .collection('UserGrp')
      .document(user['pseudo']) // just for nom when sooum finish i'll change it to id
      .get();
  print(querySnapshot.data.toString());
  if (querySnapshot.exists && querySnapshot.data.containsKey('invitations')) {
    // Create a new List<String> from List<dynamic>

    return List<Map<dynamic, dynamic>>.from(querySnapshot.data['invitations']);
  }
  return [];
}



class InvitationGrpPage extends StatefulWidget {
  @override
  _InvitationGrpPageState createState() => _InvitationGrpPageState();
  static String id = 'list_inv_grp';
}

class _InvitationGrpPageState extends State<InvitationGrpPage> {
  bool _infogrp;
  Groupe select;

  @override
  void initState() {
    // TODO: implement initState
    select = new Voyage(destination: " ");
    _infogrp = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(children: <Widget>[
          Spacer(
            flex: 2,
          ),
          Text(
            'Invitations Groupes',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: secondarycolor,
            ),
          ),
          Spacer(
            flex: 2,
          ),
          Container(
            width: 350,
            height: 390,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(59, 70, 107, 0.3),
            ),
            child: (_infogrp)
                ? ListView.builder(
                    itemCount: user.invitation_groupe.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            select = user.invitation_groupe[index];
                            _infogrp = false;
                          });
                        },
                        child: Card(
                          child: Container(
                            height: 60,
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.people,
                                  color: primarycolor,
                                  size: 30,
                                ),
                                Text('   '),
                                Text(
                                  user.invitation_groupe[index].nom,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff707070),
                                  ),
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                : (select is Voyage)
                    ? GestureDetector(
                        child: Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _infogrp = true;
                                    });
                                  },
                                  icon: Icon(Icons.arrow_back_ios),
                                  color: Color(0xff707070),
                                  iconSize: 20,
                                ),
                                Spacer(
                                  flex: 1,
                                )
                              ],
                            ),
                            Text(
                              'Un Voyage',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: secondarycolor,
                              ),
                            ),
                            Spacer(
                              flex: 2,
                            ),
                            Text(
                              select.nom,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: primarycolor,
                              ),
                            ),
                            Spacer(
                              flex: 2,
                            ),
                            Row(
                              children: <Widget>[
                                Spacer(
                                  flex: 1,
                                ),
                                Text(
                                  'vers ',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff707070),
                                  ),
                                ),
                                Text(
                                  destination(select),
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff707070),
                                  ),
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                              ],
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Row(
                              children: <Widget>[
                                Spacer(
                                  flex: 1,
                                ),
                                Text(
                                  'créé par  ',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff707070),
                                  ),
                                ),
                                Text(
                                  select.admin,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff707070),
                                  ),
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                              ],
                            ),
                            Spacer(
                              flex: 2,
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromRGBO(59, 70, 107, 0.3),
                              ),
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: select.membres.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: Container(
                                        width: 70,
                                        height: 49,
                                        child: Center(
                                          child: Text(
                                            select.membres[index],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Row(
                              children: <Widget>[
                                Spacer(
                                  flex: 1,
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      //  user.groupes.add(select);
                                      // select.membres.add(user);
                                      //  user.invitation_groupe.remove(select);
                                      _infogrp = true;
                                    });
                                  },
                                  icon: Icon(Icons.done),
                                  color: secondarycolor,
                                  iconSize: 30,
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      user.invitation_groupe.remove(select);
                                      _infogrp = true;
                                    });
                                  },
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  iconSize: 30,
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                    : GestureDetector(
                        child: Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _infogrp = true;
                                    });
                                  },
                                  icon: Icon(Icons.arrow_back_ios),
                                  color: Color(0xff707070),
                                  iconSize: 20,
                                ),
                                Spacer(
                                  flex: 1,
                                )
                              ],
                            ),
                            Text(
                              'Un Groupe a Long Terme',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: secondarycolor,
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Text(
                              select.nom,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: primarycolor,
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Row(
                              children: <Widget>[
                                Spacer(
                                  flex: 1,
                                ),
                                Text(
                                  'créé par  ',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff707070),
                                  ),
                                ),
                                Text(
                                  select.admin,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff707070),
                                  ),
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                              ],
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromRGBO(59, 70, 107, 0.3),
                              ),
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: select.membres.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: Container(
                                        width: 70,
                                        height: 49,
                                        color: Colors.white,
                                        child: Center(
                                          child: Text(
                                            select.membres[index],
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff707070),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Row(
                              children: <Widget>[
                                Spacer(
                                  flex: 1,
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      // user.groupes.add(select);
                                      // select.membres.add(user);
                                      // user.invitation_groupe.remove(select);
                                      // _infogrp = true;
                                    });
                                  },
                                  icon: Icon(Icons.done),
                                  color: secondarycolor,
                                  iconSize: 30,
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      user.invitation_groupe.remove(select);
                                      _infogrp = true;
                                    });
                                  },
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  iconSize: 30,
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
          ),
          Spacer(
            flex: 2,
          ),
        ]),
      ),
    );
  }
}

String destination(Voyage v) {
  return v.destination;
}
