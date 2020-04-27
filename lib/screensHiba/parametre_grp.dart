import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../classes.dart';
import '../dataBasehiba.dart';
import 'log_out_icon_icons.dart';
import 'nouveau_grp.dart';
import '../main.dart';

String nv_nom;
bool _confirmer;
Databasegrp data = Databasegrp();
bool _loading = false;
var _controller;

class namedialog extends StatelessWidget {
  final String nom;
  namedialog(this.nom);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(15),
      title: Text(
        'changer le nom ',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: primarycolor,
        ),
      ),
      content: TextField(
        controller: _controller,
        maxLines: 1,
        decoration: InputDecoration(
          hintText: nom,
          hintStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xff707070),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primarycolor,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: secondarycolor,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            nv_nom = _controller.text;
            _confirmer = true;
            Navigator.pop(context);
          },
          child: Text(
            'confirmer',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xff707070),
            ),
          ),
        ),
        FlatButton(
          onPressed: () {
            _confirmer = false;
            Navigator.pop(context);
          },
          child: Text(
            'annuller',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xff707070),
            ),
          ),
        ),
      ],
    );
  }
}

class ParamVoyagePage extends StatefulWidget {
  @override
  static String id = 'parametre_voyage';
  Voyage groupe;
  String path;

  ParamVoyagePage(this.groupe, this.path);

  _ParamVoyagePageState createState() => _ParamVoyagePageState(groupe, path);
}

class _ParamVoyagePageState extends State<ParamVoyagePage> {
  Voyage
  groupe; //= Voyage(nom: '', admin: '', membres: List(), destination: '');
  int index;
  String path;

  _ParamVoyagePageState(this.groupe, this.path);

  @override
  void initState() {
    _controller = TextEditingController();
    nv_nom = '';
    index = 0;
    _confirmer = false;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: GestureDetector(
        onTap: () {
          setState(() {
            index = 0;
          });
        },
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.white,
            body: IndexedStack(
              index: index,
              sizing: StackFit.expand,
              children: <Widget>[
                //page    info index=0
                Column(
                  children: <Widget>[
                    Spacer(
                      flex: 1,
                    ),
                    //carte d'info
                    Container(
                      width: 350,
                      height: 250,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Color.fromRGBO(59, 70, 107, 0.3),
                            blurRadius: 7.0,
                            offset: Offset(0.5, 1),
                          )
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Spacer(
                            flex: 1,
                          ),
                          Text(
                            'Voyage',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: primarycolor,
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          FlatButton(
                            onPressed: () async {
                              setState(() async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        namedialog(groupe.nom),
                                    barrierDismissible: true);
                                print(nv_nom);
                                print(_confirmer);
                                if (_confirmer && nv_nom != '') {
                                  await data.updategroupename(
                                      path, groupe.nom, nv_nom);
                                  groupe.nom = nv_nom;
                                }
                              });
                            },
                            child: Text(
                              groupe.nom,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: secondarycolor,
                              ),
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff707070),
                                ),
                              ),
                              Text(
                                groupe.destination,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 18,
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff707070),
                                ),
                              ),
                              Text(
                                groupe.admin,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 18,
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
                        ],
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    ListTile(
                      title: Text(
                        "Membres",
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontFamily: "Montserrat",
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(
                        Icons.person,
                        color: primarycolor,
                        size: 30,
                      ),
                      onTap: () {
                        setState(() {
                          index = 1;
                        });
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Ajouter des membres",
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontFamily: "Montserrat",
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(
                        Icons.person_add,
                        color: primarycolor,
                        size: 30,
                      ),
                      onTap: () {
                        setState(() {
                          index = 2;
                        });
                      },
                    ),
                    (data.pseudo == groupe.admin)
                        ? ListTile(
                      title: Text(
                        "Supprimer un membre",
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontFamily: "Montserrat",
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(
                        Icons.person,
                        color: primarycolor,
                        size: 30,
                      ),
                      onTap: () {
                        setState(() {
                          index = 3;
                        });
                      },
                    )
                        : Container(),
                    ListTile(
                      title: Text(
                        "Quitter le groupe",
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontFamily: "Montserrat",
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(
                        LogOutIcon.logout,
                        color: primarycolor,
                        size: 29,
                      ),
                      onTap: () {
                        setState(() {
                          _loading = true;
                        });
                        data.quittergroupe(path, groupe.nom);
                        setState(() {
                          _loading = false;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    (data.pseudo == groupe.admin)
                        ? ListTile(
                      title: Text(
                        "fermer  le groupe",
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontFamily: "Montserrat",
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(
                        LogOutIcon.logout,
                        color: primarycolor,
                        size: 29,
                      ),
                      onTap: () {
                        setState(() {
                          _loading = true;
                        });
                        data.fermergroupe(path, groupe.nom);
                        setState(() {
                          _loading = false;
                        });
                        Navigator.pop(context);
                      },
                    )
                        : Container(),
                    Spacer(
                      flex: 6,
                    ),
                  ],
                ),
                // liste des membres = 1
                /* Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Spacer(
                          flex: 3,
                        ),
                        Text('Les membres',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Color(0xff707070),
                            )),
                        Spacer(
                          flex: 1,
                        ),
                        FriendList(() {
                          //TODO go to member profil
                        }),
                        Spacer(
                          flex: 3,
                        ),
                      ]),
                ),
                //ajouter des membre = 2
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Spacer(
                          flex: 3,
                        ),
                        Text('Ajouter vos amis',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Color(0xff707070),
                            )),
                        Spacer(
                          flex: 1,
                        ),
                        Container(
                          width: 350,
                          height: 390,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffD0D8E2),
                          ),
                          child: ListView.builder(
                              itemCount: user.amis.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      setState(() {
                                        //  groupe.membres.contains(user.amis[index])
                                        //    ? groupe.membres
                                        //         .remove(user.amis[index])
                                        //      : groupe.membres
                                        //          .add(user.amis[index]);
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
                                    trailing: groupe.membres
                                            .contains(user.amis[index])
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
                              }),
                        ),
                        Spacer(
                          flex: 3,
                        ),
                      ]),
                ),*/
              ],
            )),
      ),
    );
  }
}

class ParamLongTermePage extends StatefulWidget {
  Groupe groupe;
  String path;

  ParamLongTermePage(this.groupe, this.path);

  @override
  _ParamLongTermePageState createState() =>
      _ParamLongTermePageState(groupe, path);
  static String id = 'param_long_terme';
}

class _ParamLongTermePageState extends State<ParamLongTermePage> {
  Groupe groupe;
  String path;
  int index;

  _ParamLongTermePageState(this.groupe, this.path);

  @override
  void initState() {
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          index = 0;
        });
      },
      child: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: IndexedStack(
              index: index,
              sizing: StackFit.expand,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Spacer(
                      flex: 1,
                    ),
                    Container(
                      width: 350,
                      height: 250,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Color.fromRGBO(59, 70, 107, 0.3),
                            blurRadius: 7.0,
                            offset: Offset(0.5, 1),
                          )
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Spacer(
                            flex: 1,
                          ),
                          Text(
                            'Groupe à Long Terme',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: primarycolor,
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Text(
                            groupe.nom,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: secondarycolor,
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
                                'créé par  ',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff707070),
                                ),
                              ),
                              Text(
                                groupe.admin,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 18,
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
                        ],
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    ListTile(
                      title: Text(
                        "Membres",
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontFamily: "Montserrat",
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(
                        Icons.person,
                        color: primarycolor,
                        size: 30,
                      ),
                      onTap: () {
                        setState(() {
                          index = 1;
                        });
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Ajouter des membres",
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontFamily: "Montserrat",
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(
                        Icons.person_add,
                        color: primarycolor,
                        size: 30,
                      ),
                      onTap: () {
                        setState(() {
                          index = 2;
                        });
                      },
                    ),
                    (data.pseudo == groupe.admin)
                        ? ListTile(
                      title: Text(
                        "Supprimer un membre",
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontFamily: "Montserrat",
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(
                        Icons.person,
                        color: primarycolor,
                        size: 30,
                      ),
                      onTap: () {
                        setState(() {
                          index = 3;
                        });
                      },
                    )
                        : Container(),
                    ListTile(
                      title: Text(
                        "Quitter le groupe",
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontFamily: "Montserrat",
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(
                        LogOutIcon.logout,
                        color: primarycolor,
                        size: 29,
                      ),
                      onTap: () {
                        setState(() {
                          _loading = true;
                        });
                        data.quittergroupe(path, groupe.nom);
                        setState(() {
                          _loading = false;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    (data.pseudo == groupe.admin)
                        ? ListTile(
                      title: Text(
                        "fermer  le groupe",
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontFamily: "Montserrat",
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(
                        LogOutIcon.logout,
                        color: primarycolor,
                        size: 29,
                      ),
                      onTap: () {
                        setState(() {
                          _loading = true;
                        });
                        data.fermergroupe(path, groupe.nom);
                        setState(() {
                          _loading = false;
                        });
                        Navigator.pop(context);
                      },
                    )
                        : Container(),
                    Spacer(
                      flex: 6,
                    ),
                  ],
                ),
                // liste des membres
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Spacer(
                          flex: 3,
                        ),
                        Text('Les membres',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Color(0xff707070),
                            )),
                        Spacer(
                          flex: 1,
                        ),
                        Container(
                          width: 350,
                          height: 390,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffD0D8E2),
                          ),
                          child: ListView.builder(
                              itemCount: groupe.membres.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    title: Text(
                                      groupe.membres[index]['pseudo'],
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
                                  ),
                                );
                              }),
                        ),
                        Spacer(
                          flex: 3,
                        ),
                      ]),
                ),
                //ajouter des membre
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Spacer(
                          flex: 3,
                        ),
                        Text('Ajouter vos amis',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Color(0xff707070),
                            )),
                        Spacer(
                          flex: 1,
                        ),
                        Container(
                          width: 350,
                          height: 390,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffD0D8E2),
                          ),
                          child: ListView.builder(
                              itemCount: user.amis.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      setState(() {
                                        //  groupe.membres.contains(user.amis[index])
                                        //    ? groupe.membres
                                        //         .remove(user.amis[index])
                                        //     : groupe.membres
                                        //         .add(user.amis[index]);
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
                                    trailing: groupe.membres
                                        .contains(user.amis[index])
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
                              }),
                        ),
                        Spacer(
                          flex: 3,
                        ),
                      ]),
                ),
              ],
            )),
      ),
    );
  }
}