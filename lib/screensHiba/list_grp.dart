import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'MapPage.dart';
import '../classes.dart';
import '../dataBasehiba.dart';
import '../main.dart';
import 'list_inv_grp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'parametre_grp.dart';

Database data = Database(pseudo: 'hiba');
bool _loading = false;

class ListGrpPage extends StatefulWidget {
  @override
  _ListGrpPageState createState() => _ListGrpPageState();
  static String id = 'list_grp';
}

class _ListGrpPageState extends State<ListGrpPage> {
  @override
  void initState() {
    super.initState();
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
            });
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MapVoyagePage(g)));
          } else {
            await Firestore.instance
                .document(grp_chemin)
                .get()
                .then((DocumentSnapshot doc) {
              g = LongTerme.fromMap(doc.data);
            });
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MapLongTermePage(g)));
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
                      builder: (context) => ParamVoyagePage(g, grp_chemin)));
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
                      builder: (context) => ParamLongTermePage(g, grp_chemin)));
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
      value: getListGroupes().asStream().timeout(Duration(seconds: 10),
          onTimeout: (EventSink) {
        _loading = false;
      }),
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

/*
Future<List<Groupe>> groupeslist() async {
  DocumentSnapshot querySnapshot = await Firestore.instance
      .collection('UserGrp')
      .document(data.pseudo)
      .get();
  print(querySnapshot.data['pseudo']);
  if (querySnapshot.exists &&
      querySnapshot.data.containsKey('groupes') &&
      querySnapshot.data['groupes'] is List) {
    // Create a new List<String> of ref
    List<String> grpref = List<String>.from(querySnapshot.data['groupes']);
    print(grpref);
    List<Groupe> g = List();
    for (String ref in grpref) {
      if (ref.startsWith('LongTerme')) {
        _firestore.document(ref).get().then((DocumentSnapshot doc) {
          g.add(LongTerme.fromMap(doc.data));
          print(g.last.nom);
        });
      }
      if (ref.startsWith('Voyage')) {
        Firestore.instance.document(ref).get().then((DocumentSnapshot doc) {
          g.add(Voyage.fromMap(doc.data));
          print(g.last.nom);
        });
      }
    }
    return g;
  }
}
*/
Future<List<Map<dynamic, dynamic>>> getListGroupes() async {
  DocumentSnapshot querySnapshot = await Firestore.instance
      .collection('UserGrp')
      .document(data.pseudo)
      .get();
  print(querySnapshot.data.toString());
  if (querySnapshot.exists && querySnapshot.data.containsKey('groupes')) {
    // Create a new List<String> from List<dynamic>

    return List<Map<dynamic, dynamic>>.from(querySnapshot.data['groupes']);
  }
  return [];
}
