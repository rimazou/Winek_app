import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:winek/classes.dart';
import 'package:winek/main.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winek/dataBasehiba.dart';
import 'dart:ui';
import 'dart:io';

final GlobalKey<ScaffoldState> _listinvKey = new GlobalKey<ScaffoldState>();
Databasegrp data = Databasegrp();

Stream invitation;
bool _loading;
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
    _voyage = Voyage(
        nom: ' ',
        membres: List<Map<dynamic, dynamic>>(),
        admin: '',
        destination: " ");
    _longTerme =
        LongTerme(nom: ' ', membres: List<Map<dynamic, dynamic>>(), admin: '');
    index = 0;

    invitation = data.getListInvitations().asStream();
    setState(() {
      _loading = false;
    });
  }

  void switchindex(int value) {
    setState(() {
      index = value;
    });
  }

  _showSnackBar(String value, BuildContext context) {
    _listinvKey.currentState.showSnackBar(SnackBar(
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
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Map<dynamic, dynamic>>>.value(
      value: invitation,
      child: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Scaffold(
          key: _listinvKey,
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
                            flex: 1,
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
                            flex: 1,
                          ),
                          Expanded(
                            child: Container(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.all(0.1),
                                child: RichText(
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                      text: 'vers ',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff707070),
                                      ),
                                    ),
                                    TextSpan(
                                      text: _voyage.destination,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff707070),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
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
                                itemCount: _voyage.membres.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Container(
                                      width: 70,
                                      height: 49,
                                      child: Center(
                                        child: Text(
                                          _voyage.membres[index]['pseudo'],
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
                                  try {
                                    final result = await InternetAddress.lookup(
                                        'google.com');
                                    var result2 = await Connectivity()
                                        .checkConnectivity();
                                    var b =
                                        (result2 != ConnectivityResult.none);

                                    if (b &&
                                        result.isNotEmpty &&
                                        result[0].rawAddress.isNotEmpty) {
                                      setState(() {
                                        _loading = true;
                                      });
                                      await data.acceptinvitation(
                                          ref, _voyage.nom);
                                      setState(() {
                                        invitation = data
                                            .getListInvitations()
                                            .asStream();
                                        _loading = false;
                                        index = 0;
                                      });
                                    }
                                  } on SocketException catch (_) {
                                    _showSnackBar(
                                        'Vérifiez votre connexion internet',
                                        context);
                                  }
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
                                  try {
                                    final result = await InternetAddress.lookup(
                                        'google.com');
                                    var result2 = await Connectivity()
                                        .checkConnectivity();
                                    var b =
                                        (result2 != ConnectivityResult.none);

                                    if (b &&
                                        result.isNotEmpty &&
                                        result[0].rawAddress.isNotEmpty) {
                                      setState(() {
                                        _loading = true;
                                      });
                                      await data.refuseinvitation(
                                          ref, _voyage.nom);
                                      setState(() {
                                        invitation = data
                                            .getListInvitations()
                                            .asStream();
                                        _loading = false;
                                        index = 0;
                                      });
                                    }
                                  } on SocketException catch (_) {
                                    _showSnackBar(
                                        'Vérifiez votre connexion internet',
                                        context);
                                  }
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
                                          _longTerme.membres[index]['pseudo'],
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
                                  try {
                                    final result = await InternetAddress.lookup(
                                        'google.com');
                                    var result2 = await Connectivity()
                                        .checkConnectivity();
                                    var b =
                                        (result2 != ConnectivityResult.none);

                                    if (b &&
                                        result.isNotEmpty &&
                                        result[0].rawAddress.isNotEmpty) {
                                      setState(() {
                                        _loading = true;
                                      });
                                      await data.acceptinvitation(
                                          ref, _longTerme.nom);
                                      setState(() {
                                        invitation = data
                                            .getListInvitations()
                                            .asStream();
                                        _loading = false;
                                        index = 0;
                                      });
                                    }
                                  } on SocketException catch (_) {
                                    _showSnackBar(
                                        'Vérifiez votre connexion internet',
                                        context);
                                  }
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
                                  setState(() {
                                    _loading = true;
                                  });
                                  await data.refuseinvitation(
                                      ref, _longTerme.nom);
                                  setState(() {
                                    invitation =
                                        data.getListInvitations().asStream();
                                    _loading = false;
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
                return 1;
              } else {
                _longTerme = LongTerme.fromMap(doc.data);
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
