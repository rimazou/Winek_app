import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:winek/auth.dart';
import 'MapPage.dart';
import '../classes.dart';
import '../dataBasehiba.dart';
import '../main.dart';
import 'list_inv_grp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'parametre_grp.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import '../UpdateMarkers.dart';
import 'MapPage.dart';

bool _loading;

class ListGrpPage extends StatefulWidget {
  @override
  _ListGrpPageState createState() => _ListGrpPageState();
  static String id = 'list_grp';
}

class _ListGrpPageState extends State<ListGrpPage> {
  @override
  void initState() {
    super.initState();
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: <Widget>[
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
                      Navigator.pushNamed(context, InvitationGrpPage.id);
                    },
                    icon: Icon(Icons.supervised_user_circle),
                    color: primarycolor,
                    iconSize: 40,
                  ),
                ],
              ),
              Spacer(
                flex: 1,
              ),
              Text(
                'Vos Groupes',
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
                child: Groupeprovider(),
              ),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class grpTile extends StatelessWidget {
  final String grp_nom;
  final String grp_chemin;

  grpTile({@required this.grp_nom, @required this.grp_chemin});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async {
          Groupe g = Voyage();
          if (grp_chemin.startsWith('Voyage')) {
            await Firestore.instance
                .document(grp_chemin)
                .get()
                .then((DocumentSnapshot doc) {
              g = Voyage.fromMap(doc.data);
              //print(g.membres);
            });
            List<String> images = List();
            for (Map member in g.membres) {
              String url = await Firestore.instance
                  .collection('Utilisateur')
                  .document(member['id'])
                  .get()
                  .then((doc) {
                return doc.data['photo'].toString();
              });
              images.add(url);
            }
            Provider.of<UpdateMarkers>(context, listen: false).markers.clear();
            Provider.of<UpdateMarkers>(context, listen: false)
                .UpdateusersLocation(grp_chemin, context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MapVoyagePage(g, grp_chemin, images)));
            //asma initialise
            groupPath = grp_chemin;
            utilisateurID = await AuthService().connectedID();
            currentUser =
            await AuthService().getPseudo(utilisateurID);
            stackIndex = 3;
          }
          if (grp_chemin.startsWith('LongTerme')) {
            await Firestore.instance
                .document(grp_chemin)
                .get()
                .then((DocumentSnapshot doc) {
              g = LongTerme.fromMap(doc.data);
            });
            List<String> images = List();
            for (Map member in g.membres) {
              String url = await Firestore.instance
                  .collection('Utilisateur')
                  .document(member['id'])
                  .get()
                  .then((doc) {
                return doc.data['photo'].toString();
              });
              images.add(url);
            }
            Provider.of<UpdateMarkers>(context, listen: false).markers.clear();
            Provider.of<UpdateMarkers>(context, listen: false)
                .UpdateusersLocation(grp_chemin, context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MapLongTermePage(g, grp_chemin, images)));
          }
        },
        title: Text(
          grp_nom,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Color(0xff707070),
          ),
        ),
        leading: Icon(
          Icons.people,
          color: primarycolor,
          size: 30,
        ),
        trailing: IconButton(
          onPressed: () async {
            String id = await authService.connectedID();
            String pseudo = await Firestore.instance
                .collection('Utilisateur')
                .document(id)
                .get()
                .then((doc) {
              return doc.data['pseudo'];
            });

            print("current user :$pseudo");
            Groupe g = Voyage();
            if (grp_chemin.startsWith('Voyage')) {
              await Firestore.instance
                  .document(grp_chemin)
                  .get()
                  .then((DocumentSnapshot doc) {
                g = Voyage.fromMap(doc.data);
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ParamVoyagePage(g, grp_chemin, pseudo)));
            } else {
              await Firestore.instance
                  .document(grp_chemin)
                  .get()
                  .then((DocumentSnapshot doc) {
                g = LongTerme.fromMap(doc.data);
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ParamLongTermePage(g, grp_chemin, pseudo)));
            }
          },
          icon: Icon(Icons.info_outline),
          color: secondarycolor,
          iconSize: 30,
        ),
      ),
    );
  }
}

class Groupeprovider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Map<dynamic, dynamic>>>.value(
      value: getListGroupes().asStream(),
      child: GroupesList(),
    );
  }
}

class GroupesList extends StatefulWidget {
  @override
  _GroupesListState createState() => _GroupesListState();
}

class _GroupesListState extends State<GroupesList> {
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
        return grpTile(
          grp_nom: grps[index]['nom'],
          grp_chemin: grps[index]['chemin'],
        );
      },
    );
  }
}

Future<List<Map<dynamic, dynamic>>> getListGroupes() async {
  Map user = {'pseudo': '', 'id': ''};
  user['id'] = await authService.connectedID();
  user['pseudo'] = await Firestore.instance
      .collection('Utilisateur')
      .document(user['id'])
      .get()
      .then((Doc) {
    return Doc.data['pseudo'];
  });
  // await Databasegrp.getcurret(user['id'], user['pseudo']);
  print("user : $user");
  DocumentSnapshot querySnapshot =
      await Firestore.instance.collection('UserGrp').document(user['id']).get();
  print(querySnapshot.data.toString());
  if (querySnapshot.exists && querySnapshot.data.containsKey('groupes')) {
    // Create a new List<String> from List<dynamic>

    return List<Map<dynamic, dynamic>>.from(querySnapshot.data['groupes']);
  }
  return [];
}
