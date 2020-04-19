import 'package:flutter/material.dart';
import 'package:winek/classes.dart';
import 'package:winek/main.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winek/dataBasehiba.dart';

Database data = Database();

Stream invitation;
bool waiting;
Voyage _voyage;
LongTerme _longTerme;
String ref = '';

class InvitationGrpPage extends StatefulWidget {
  @override
  _InvitationGrpPageState createState() => _InvitationGrpPageState();
  static String id = 'list_inv_grp';
}

class _InvitationGrpPageState extends State<InvitationGrpPage> {
  int index;
  int count;
  @override
  void initState() {
    _voyage = Voyage(nom: ' ', membres: List(), admin: '', destination: " ");
    _longTerme = LongTerme(nom: ' ', membres: List(), admin: '');
    index = 0;
    setState(() {
      waiting = true;
    });
    invitation = data.getListInvitations().asStream();
    setState(() {
      waiting = false;
    });
  }

  void switchindex(int value) {
    setState(() {
      index = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Map<dynamic, dynamic>>>.value(
      value: invitation,
      child: Scaffold(
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
              child: IndexedStack(
                index: index,
                children: <Widget>[
                  // liste des invitation = 0
                  InvitationsList(switchindex),
                  //Voyage card
                  GestureDetector(
                      child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                switchindex(0);
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
                          _voyage.nom,
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
                              _voyage.destination,
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
                              _voyage.admin,
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
                              itemCount: _voyage.membres.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Container(
                                    width: 70,
                                    height: 49,
                                    child: Center(
                                      child: Text(
                                        _voyage.membres[index],
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
                              onPressed: () async {
                                await data.acceptinvitation(ref, _voyage.nom);
                                setState(() {
                                  index = 0;
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
                              onPressed: () async {
                                await data.refuseinvitation(ref, _voyage.nom);
                                setState(() {
                                  invitation = getListInvitations().asStream();
                                  index = 0;
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
                  //long terme card
                  GestureDetector(
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
                                  index = 0;
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
                          _longTerme.nom,
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
                              _longTerme.admin,
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
                              itemCount: _longTerme.membres.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Container(
                                    width: 70,
                                    height: 49,
                                    color: Colors.white,
                                    child: Center(
                                      child: Text(
                                        _longTerme.membres[index],
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
                              onPressed: () async {
                                await data.acceptinvitation(
                                    ref, _longTerme.nom);
                                setState(() {
                                  index = 0;
                                });
                              },
                              icon: Icon(Icons.done),
                              color: secondarycolor,
                              iconSize: 30,
                            ),
                            IconButton(
                              onPressed: () async {
                                await data.refuseinvitation(
                                    ref, _longTerme.nom);
                                setState(() {
                                  invitation = getListInvitations().asStream();
                                  index = 0;
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
                ],
              ),
            ),
            Spacer(
              flex: 2,
            ),
          ]),
        ),
      ),
    );
  }
}

class InvitationsList extends StatefulWidget {
  Function changeindex;

  InvitationsList(this.changeindex);

  @override
  _InvitationsListState createState() => _InvitationsListState(changeindex);
}

class _InvitationsListState extends State<InvitationsList> {
  Function changeindex;

  _InvitationsListState(this.changeindex);

  @override
  Widget build(BuildContext context) {
    final grps = Provider.of<List<Map<dynamic, dynamic>>>(context);
    int count;
    setState(() {
      if (grps != null) {
        count = grps.length;
        print('count: $count');
      } else {
        count = 0;
      }
    });
    return ListView.builder(
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            ref = grps[index]['chemin'];
            int i = await Firestore.instance
                .document(grps[index]['chemin'])
                .get()
                .then((DocumentSnapshot doc) {
              if (grps[index]['chemin'].toString().startsWith('Voyage')) {
                _voyage = Voyage.fromMap(doc.data);
                print(_voyage.nom);
                return 1;
              } else {
                _longTerme = LongTerme.fromMap(doc.data);
                print(_longTerme.nom);
                return 2;
              }
            });
            changeindex(i);
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
                    grps[index]['nom'],
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
      },
    );
  }
}

Future<List<Map<dynamic, dynamic>>> getListInvitations() async {
  DocumentSnapshot querySnapshot = await Firestore.instance
      .collection('UserGrp')
      .document(data.pseudo)
      .get();
  if (querySnapshot.exists && querySnapshot.data.containsKey('invitations')) {
    // Create a new List<String> from List<dynamic>

    return List<Map<dynamic, dynamic>>.from(querySnapshot.data['invitations']);
  }
  return [];
}
