import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../classes.dart';
import '../dataBasehiba.dart';
import 'log_out_icon_icons.dart';
import 'nouveau_grp.dart';
import '../main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winek/auth.dart';
import 'package:provider/provider.dart';
import 'package:winek/screensSoum/profile.dart';

String nv_nom;
bool _confirmer;
Databasegrp data = Databasegrp();
bool _loading;
var _controller;
List membres;

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

class deletememberdialog extends StatelessWidget {
  final String member;
  final Function _function;
  deletememberdialog(this.member, this._function);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.all(15),
      title: Text(
        'supprimez un membre',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: primarycolor,
        ),
      ),
      content: RichText(
        text: TextSpan(children: <TextSpan>[
          TextSpan(
            text: 'Êtes vous sur de vouloir supprimer ',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color(0xff707070),
            ),
          ),
          TextSpan(
            text: member,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: secondarycolor,
            ),
          ),
        ]),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _function;
            Navigator.pop(context);
          },
          child: Text(
            'oui',
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
  String currentuser;
  ParamVoyagePage(this.groupe, this.path, this.currentuser);

  _ParamVoyagePageState createState() =>
      _ParamVoyagePageState(groupe, path, currentuser);
}

class _ParamVoyagePageState extends State<ParamVoyagePage> {
  Voyage
      groupe; //= Voyage(nom: '', admin: '', membres: List(), destination: '');
  int index;
  String path;
  String currentuser;
  _ParamVoyagePageState(this.groupe, this.path, this.currentuser);

  @override
  void initState() {
    _controller = TextEditingController();
    nv_nom = '';
    index = 0;
    _confirmer = false;
    _loading = false;
    membres = List<Map>();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.white,
          body: IndexedStack(
            index: index,
            sizing: StackFit.expand,
            children: <Widget>[
              //page principale index=0
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
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    //   namedialog(groupe.nom),
                                    AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
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
                                          hintText: groupe.nom,
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
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: secondarycolor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () async {
                                            nv_nom = _controller.text;
                                            setState(() {
                                              _loading = true;
                                            });
                                            if (nv_nom != '') {
                                              await data.updategroupename(
                                                  path, groupe.nom, nv_nom);
                                            }
                                            setState(() {
                                              _loading = false;
                                              groupe.nom = nv_nom;
                                            });
                                            // nv_nom = _controller.text;
                                            // _confirmer = true;
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
                                    ),
                                barrierDismissible: true);
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
                                    text: groupe.destination,
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
                  (currentuser == groupe.admin)
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
                  (currentuser == groupe.admin)
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
                          onTap: () async {
                            setState(() {
                              _loading = true;
                            });
                            await data.fermergroupe(path, groupe.nom);
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
              Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: primarycolor,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                index = 0;
                              });
                            },
                          ),
                          Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Text('Les membres',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: secondarycolor,
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
                          color: Color.fromRGBO(59, 70, 107, 0.3),
                        ),
                        child: ListView.builder(
                            itemCount: groupe.membres.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  onTap: () async {
                                    String currentUser =
                                        await AuthService().connectedID();
                                    String name = await Firestore.instance
                                        .collection('Utilisateur')
                                        .document(currentUser)
                                        .get()
                                        .then((Doc) {
                                      return Doc.data['pseudo'];
                                    });
                                    //go to the profile screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfileScreen2(
                                                friend: groupe.membres[index],
                                                currentUser: currentUser,
                                                name: name,
                                              )),
                                    );
                                  },
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
              //ajouter des membre = 2
              Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: primarycolor,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                index = 0;
                              });
                            },
                          ),
                          Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Text('Ajoutez vos amis',
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
                        child: FriendList((var member) {
                          membres.contains(member)
                              ? membres.remove(member)
                              : membres.add(member);
                        }),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Container(
                        height: 38,
                        width: 155,
                        decoration: BoxDecoration(
                          color: Color(0xff389490),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: FlatButton(
                          onPressed: () async {
                            if (membres.isNotEmpty) {
                              setState(() {
                                _loading = true;
                              });
                              for (var m in membres) {
                                // print(m['id']);
                                await data.invitemember(
                                    path, groupe.nom, m['id']);
                              }
                              setState(() {
                                _loading = false;
                                index = 0;
                              });
                            }
                          },
                          child: Center(
                            child: Text(
                              'Ajouter',
                              style: TextStyle(
                                fontFamily: 'montserrat',
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                    ]),
              ),
              //supprimer membre= 3
              Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: primarycolor,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                index = 0;
                              });
                            },
                          ),
                          Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Text('supprimez un membre',
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
                          color: Color.fromRGBO(59, 70, 107, 0.3),
                        ),
                        child: ListView.builder(
                            itemCount: groupe.membres.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  onTap: () async {
                                    print('membre: ${groupe.membres[index]}');
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        contentPadding: EdgeInsets.all(15),
                                        title: Text(
                                          'supprimez un membre',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 19,
                                            fontWeight: FontWeight.w700,
                                            color: primarycolor,
                                          ),
                                        ),
                                        content: RichText(
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  'Êtes vous sur de vouloir supprimer ',
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff707070),
                                              ),
                                            ),
                                            TextSpan(
                                              text: groupe.membres[index]
                                                  ['pseudo'],
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: secondarycolor,
                                              ),
                                            ),
                                          ]),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () async {
                                              setState(() {
                                                _loading = true;
                                              });
                                              await data.deletemember(
                                                  path,
                                                  groupe.nom,
                                                  groupe.membres[index]['id'],
                                                  groupe.membres[index]
                                                      ['pseudo']);
                                              setState(() {
                                                groupe.membres.remove(
                                                    groupe.membres[index]);
                                              });
                                              setState(() {
                                                _loading = false;
                                              });
                                              print('bien supprimer');
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'oui',
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
                                      ),
                                    );
                                    /* deletememberdialog(
                                                groupe.membres[index]['pseudo'],
                                                () async {
                                              await data.deletemember(
                                                  path,
                                                  groupe.nom,
                                                  groupe.membres[index]['id'],
                                                  groupe.membres[index]
                                                      ['pseudo']);
                                            }),
                                        barrierDismissible: true); */
                                  },
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
            ],
          )),
    );
  }
}

class ParamLongTermePage extends StatefulWidget {
  Groupe groupe;
  String path;
  String currentuser;

  ParamLongTermePage(this.groupe, this.path, this.currentuser);

  @override
  _ParamLongTermePageState createState() =>
      _ParamLongTermePageState(groupe, path, currentuser);
  static String id = 'param_long_terme';
}

class _ParamLongTermePageState extends State<ParamLongTermePage> {
  Groupe groupe;
  String path;
  int index;
  String currentuser;

  _ParamLongTermePageState(this.groupe, this.path, this.currentuser);

  @override
  void initState() {
    _controller = TextEditingController();
    nv_nom = '';
    index = 0;
    _confirmer = false;
    _loading = false;
    membres = List<Map>();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        FlatButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    //   namedialog(groupe.nom),
                                    AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
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
                                          hintText: groupe.nom,
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
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: secondarycolor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () async {
                                            nv_nom = _controller.text;
                                            setState(() {
                                              _loading = true;
                                            });
                                            if (nv_nom != '') {
                                              await data.updategroupename(
                                                  path, groupe.nom, nv_nom);
                                            }
                                            setState(() {
                                              _loading = false;
                                              groupe.nom = nv_nom;
                                            });
                                            // nv_nom = _controller.text;
                                            // _confirmer = true;
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
                                    ),
                                barrierDismissible: true);
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
                  (currentuser == groupe.admin)
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
                  (currentuser == groupe.admin)
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
                          onTap: () async {
                            setState(() {
                              _loading = true;
                            });
                            await data.fermergroupe(path, groupe.nom);
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
              Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: primarycolor,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                index = 0;
                              });
                            },
                          ),
                          Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Text('Les membres',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: secondarycolor,
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
                          color: Color.fromRGBO(59, 70, 107, 0.3),
                        ),
                        child: ListView.builder(
                            itemCount: groupe.membres.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  onTap: () async {
                                    String currentUser =
                                        await AuthService().connectedID();
                                    String name = await Firestore.instance
                                        .collection('Utilisateur')
                                        .document(currentUser)
                                        .get()
                                        .then((Doc) {
                                      return Doc.data['pseudo'];
                                    });
                                    //go to the profile screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfileScreen2(
                                                friend: groupe.membres[index],
                                                currentUser: currentUser,
                                                name: name,
                                              )),
                                    );
                                  },
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
              //ajouter des membre = 2
              Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: primarycolor,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                index = 0;
                              });
                            },
                          ),
                          Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Text('Ajoutez vos amis',
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
                        child: FriendList((var member) {
                          membres.contains(member)
                              ? membres.remove(member)
                              : membres.add(member);
                        }),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Container(
                        height: 38,
                        width: 155,
                        decoration: BoxDecoration(
                          color: Color(0xff389490),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: FlatButton(
                          onPressed: () async {
                            if (membres.isNotEmpty) {
                              setState(() {
                                _loading = true;
                              });
                              for (var m in membres) {
                                // print(m['id']);
                                await data.invitemember(
                                    path, groupe.nom, m['id']);
                              }
                              setState(() {
                                _loading = false;
                                index = 0;
                              });
                            }
                          },
                          child: Center(
                            child: Text(
                              'Ajouter',
                              style: TextStyle(
                                fontFamily: 'montserrat',
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                    ]),
              ),
              //supprimer membre= 3
              Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: primarycolor,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                index = 0;
                              });
                            },
                          ),
                          Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Text('supprimez un membre',
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
                          color: Color.fromRGBO(59, 70, 107, 0.3),
                        ),
                        child: ListView.builder(
                            itemCount: groupe.membres.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  onTap: () async {
                                    print('membre: ${groupe.membres[index]}');
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        contentPadding: EdgeInsets.all(15),
                                        title: Text(
                                          'supprimez un membre',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 19,
                                            fontWeight: FontWeight.w700,
                                            color: primarycolor,
                                          ),
                                        ),
                                        content: RichText(
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  'Êtes vous sur de vouloir supprimer ',
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff707070),
                                              ),
                                            ),
                                            TextSpan(
                                              text: groupe.membres[index]
                                                  ['pseudo'],
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: secondarycolor,
                                              ),
                                            ),
                                          ]),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () async {
                                              setState(() {
                                                _loading = true;
                                              });
                                              await data.deletemember(
                                                  path,
                                                  groupe.nom,
                                                  groupe.membres[index]['id'],
                                                  groupe.membres[index]
                                                      ['pseudo']);
                                              setState(() {
                                                groupe.membres.remove(
                                                    groupe.membres[index]);
                                              });
                                              setState(() {
                                                _loading = false;
                                              });
                                              print('bien supprimer');
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'oui',
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
                                      ),
                                    );
                                    /* deletememberdialog(
                                                groupe.membres[index]['pseudo'],
                                                () async {
                                              await data.deletemember(
                                                  path,
                                                  groupe.nom,
                                                  groupe.membres[index]['id'],
                                                  groupe.membres[index]
                                                      ['pseudo']);
                                            }),
                                        barrierDismissible: true); */
                                  },
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
            ],
          )),
    );
  }
}

class FriendList extends StatelessWidget {
  final Function _function;

  FriendList(this._function);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Map<dynamic, dynamic>>>.value(
        value: getlistfreind().asStream(),
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: FriendsList(_function),
        ));
  }
}

class FriendsList extends StatefulWidget {
  final Function _function;

  FriendsList(this._function);

  @override
  _FriendsListState createState() => _FriendsListState(_function);
}

class _FriendsListState extends State<FriendsList> {
  final Function _function;

  _FriendsListState(this._function);

  @override
  Widget build(BuildContext context) {
    final friends = Provider.of<List<Map<dynamic, dynamic>>>(context);
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
        return Card(
          child: ListTile(
            onTap: () {
              setState(() {
                _function(friends[index]);
              });
            },
            title: Text(
              friends[index]['pseudo'],
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
            trailing: membres.contains(friends[index])
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
      },
    );
  }
}

Future<List<Map<dynamic, dynamic>>> getlistfreind() async {
  String id = await authService.connectedID();
  print(id);
  List<Map<dynamic, dynamic>> friendsid = List<Map>();
  await Firestore.instance
      .collection('Utilisateur')
      .document(id)
      .get()
      .then((DocumentSnapshot doc) {
    friendsid = List<Map>.from(doc.data['amis']);
  });
  print(friendsid);
  /* List<dynamic> pseudos = List();
  for (String id in friendsid) {
    await Firestore.instance
        .collection('Utilisateur')
        .document(id)
        .get()
        .then((DocumentSnapshot doc) {
      pseudos.add(doc.data['pseudo']);
    });
  }
  print(pseudos);
  List<Map<dynamic, dynamic>> friendlist = List();
  for (int index = 0; index < friendsid.length; index++) {
    friendlist.add({'pseudo': pseudos[index], 'id': friendsid[index]});
  } */
  return friendsid;
}
