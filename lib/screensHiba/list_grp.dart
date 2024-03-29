import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:winek/auth.dart';
import 'MapPage.dart';
import '../classes.dart';
import '../main.dart';
import 'list_inv_grp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'parametre_grp.dart';
import 'package:flutter/cupertino.dart';
import '../UpdateMarkers.dart';

bool _loading;
final GlobalKey<ScaffoldState> _scaffoldgrpKey = new GlobalKey<ScaffoldState>();

class ListGrpPage extends StatefulWidget {
  @override
  _ListGrpPageState createState() => _ListGrpPageState();
  static String id = 'list_grp';
}

void spinner() {
  _loading = !_loading;
}

class _ListGrpPageState extends State<ListGrpPage> {
  @override
  void initState() {
    _loading = false;
  }

  _showSnkBar(String value, BuildContext context) {
    _scaffoldgrpKey.currentState.showSnackBar(SnackBar(
      content: new Text(
        value,
        style: TextStyle(
            color: Colors.white,
            fontSize: responsivetext(14.0),
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600),
      ),
      duration: new Duration(seconds: 2),
      //backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Scaffold(
        key: _scaffoldgrpKey,
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
                    onPressed: () async {
                      try {
                        final result =
                            await InternetAddress.lookup('google.com');
                        var result2 = await Connectivity().checkConnectivity();
                        var b = (result2 != ConnectivityResult.none);

                        if (b &&
                            result.isNotEmpty &&
                            result[0].rawAddress.isNotEmpty) {
                          Navigator.pushNamed(context, InvitationGrpPage.id);
                        }
                      } on SocketException catch (_) {
                        _showSnkBar(
                            'Vérifiez votre connexion internet', context);
                      }
                    },
                    icon: Icon(Icons.supervised_user_circle),
                    color: primarycolor,
                    iconSize: responsivewidth(40),
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
                  fontSize: responsivetext(25),
                  fontWeight: FontWeight.w900,
                  color: secondarycolor,
                ),
              ),
              Spacer(
                flex: 2,
              ),
              Container(
                width: responsivewidth(350),
                height: responsiveheight(390),
                padding: EdgeInsets.symmetric(
                    horizontal: responsivewidth(10),
                    vertical: responsiveheight(10)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(responsiveradius(10, 1)),
                  color: Color.fromRGBO(59, 70, 107, 0.3),
                ),
                child: Groupeprovider(() {
                  spinner();
                }),
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
  final Function function;
  grpTile(
      {@required this.grp_nom,
      @required this.grp_chemin,
      @required this.function});

  _showSnackBar(String value, BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(SnackBar(
      content: new Text(
        value,
        style: TextStyle(
            color: Colors.white,
            fontSize: responsivetext(14.0),
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
        onTap: () async {
          try {
            final result = await InternetAddress.lookup('google.com');
            var result2 = await Connectivity().checkConnectivity();
            var b = (result2 != ConnectivityResult.none);

            if (b && result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              () {
                function();
              };
              Groupe g = Voyage();
              if (grp_chemin.startsWith('Voyage')) {
                await Firestore.instance
                    .document(grp_chemin)
                    .get()
                    .then((DocumentSnapshot doc) {
                  g = Voyage.fromMap(doc.data);
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
                Provider.of<UpdateMarkers>(context, listen: false)
                    .markers
                    .clear();
                Provider.of<UpdateMarkers>(context, listen: false)
                    .UpdateusersLocation(grp_chemin, context);
                Provider.of<UpdateMarkers>(context, listen: false)
                    .getChanges(context, grp_chemin);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MapVoyagePage(g, grp_chemin, images)));

                groupPath = grp_chemin;
                utilisateurID = await AuthService().connectedID();
                currentUser = await AuthService().getPseudo(utilisateurID);
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
                Provider.of<UpdateMarkers>(context, listen: false)
                    .markers
                    .clear();
                Provider.of<UpdateMarkers>(context, listen: false)
                    .UpdateusersLocationlt(grp_chemin, context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MapLongTermePage(g, grp_chemin, images)));
              }

              () {
                // ignore: unnecessary_statements
                function();
              };
            }
          } on SocketException catch (_) {
            _showSnackBar('Vérifiez votre connexion internet', context);
          }
        },
        title: Text(
          grp_nom,
          style: TextStyle(
            fontSize: responsivetext(14),
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Color(0xff707070),
          ),
        ),
        leading: Icon(
          Icons.people,
          color: primarycolor,
          size: responsivewidth(30),
        ),
        trailing: IconButton(
          onPressed: () async {
            try {
              final result = await InternetAddress.lookup('google.com');
              var result2 = await Connectivity().checkConnectivity();
              var b = (result2 != ConnectivityResult.none);

              if (b && result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                String id = await authService.connectedID();
                String pseudo = await Firestore.instance
                    .collection('Utilisateur')
                    .document(id)
                    .get()
                    .then((doc) {
                  return doc.data['pseudo'];
                });

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
              }
            } on SocketException catch (_) {
              _showSnackBar('Vérifiez votre connexion internet', context);
            }
          },
          icon: Icon(Icons.info_outline),
          color: secondarycolor,
          iconSize: responsivewidth(30),
        ),
      ),
    );
  }
}

class Groupeprovider extends StatelessWidget {
  final Function _function;

  Groupeprovider(this._function);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Map<dynamic, dynamic>>>.value(
      value: getListGroupes().asStream(),
      child: GroupesList(_function),
    );
  }
}

class GroupesList extends StatefulWidget {
  Function fonction;

  GroupesList(this.fonction);

  @override
  _GroupesListState createState() => _GroupesListState(fonction);
}

class _GroupesListState extends State<GroupesList> {
  Function function;

  _GroupesListState(this.function);

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
        return grpTile(
          grp_nom: grps[index]['nom'],
          grp_chemin: grps[index]['chemin'],
          function: () {
            function();
          },
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

  DocumentSnapshot querySnapshot =
      await Firestore.instance.collection('UserGrp').document(user['id']).get();

  if (querySnapshot.exists && querySnapshot.data.containsKey('groupes')) {
    return List<Map<dynamic, dynamic>>.from(querySnapshot.data['groupes']);
  }
  return [];
}
