import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:winek/auth.dart';
import 'package:winek/screensHiba/parametre_grp.dart';
import '../main.dart';
import '../classes.dart';
import '../dataBasehiba.dart';
import 'list_grp.dart';

//Database data = Database(pseudo: 'hiba', id: id);
bool _alerte_nom = false;
bool _alerte_mbr = false;
String nom_grp = "";
var _controller;
Groupe nv_grp;
String _destination;
List<String> membres;
bool _loading = false;
final _firestore = Firestore.instance;

void createlongterme() async {
  // get the current user info
  Map user ={ 'pseudo': '' , 'id': ''};
  await Database.getcurret(user['id'], user['pseudo']);
  // creationg the doc of the grp
  DocumentReference ref = await _firestore.collection('LongTerme').add({
    'nom': nom_grp,
    'admin': user['pseudo'],
    'membres': [
      user
    ], // since he's the admin, others have to accept the invitation first
  });
  Map grp = {'chemin': ref.path, 'nom': nom_grp};
  // adding that grp to member's invitations liste.
  for (String m in membres) {
    DocumentSnapshot doc =
        await Firestore.instance.collection('UserGrp').document(m).get();
    if (doc.exists) {
      if (doc.data.containsKey('invitations')) {
        doc.reference.updateData({
          'invitations': FieldValue.arrayUnion([grp])
        });
      } else {
        doc.reference.updateData({
          'invitations': [grp]
        });
      }
    } else {
      Firestore.instance.collection('UserGrp').document(m).setData({
        'pseudo': m,
        'invitations': [grp]
      });
    }
  }
  //adding the grp into the admin list of grp
  await Firestore.instance
      .collection('UserGrp')
      .document(user['id'])
      .updateData({
    'groupes': FieldValue.arrayUnion([grp])
  });
}


class NvLongTermePage extends StatefulWidget {
  @override
  _NvLongTermePageState createState() => _NvLongTermePageState();
  static String id = 'nv_long_terme';
}

class _NvLongTermePageState extends State<NvLongTermePage> {
  bool _loading = false;

  @override
  void initState() {
    membres = new List();
    _controller = TextEditingController();
  }

  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Spacer(
              flex: 1,
            ),
            Center(
              child: Text(
                'Nouveau groupe',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff3B466B),
                ),
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Container(
              height: 43,
              width: 321,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color.fromRGBO(59, 70, 107, 0.3),
                    blurRadius: 7.0,
                    offset: Offset(0.0, 0.75),
                  )
                ],
              ),
              child: TextField(
                onTap: () {
                  setState(() {
                    _alerte_nom = false;
                  });
                },
                controller: _controller,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: '   Nom du groupe',
                  hintStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff707070),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _alerte_nom ? Colors.red : primarycolor,
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
            ),
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child: Text(
                '    Ajouter vos amis',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: _alerte_mbr ? Colors.red : Color(0xff707070),
                ),
              ),
            ),
            Container(
              width: 350,
              height: 250,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(59, 70, 107, 0.3),
              ),
              child: FriendList((String membername) {
                membres.contains(membername)
                    ? membres.remove(membername)
                    : membres.add(membername);
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
                  print(_controller.text);
                  print(membres.length);
                  setState(() {
                    if (_controller.text.isEmpty) {
                      _alerte_nom = true;
                    } else {
                      _alerte_nom = false;
                      nom_grp = _controller.text;
                    }
                    if (membres.isEmpty) {
                      _alerte_mbr = true;
                    } else {
                      _alerte_mbr = false;
                    }
                    if (nom_grp.isNotEmpty && membres.isNotEmpty) {
                      setState(() {
                        _loading = true;
                      });
                      createlongterme();
                      setState(() {
                        _loading = false;
                      });
                      Navigator.pushNamed(context, ListGrpPage.id);
                    }
                  });
                },
                child: Center(
                  child: Text(
                    'Créer',
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
            )
          ],
        ),
      ),
    );
  }
}

//----------------------------------------------------------------------------------//
void createvoyage() async {
  // creationg the doc of the grp
  Map user ={ 'pseudo': '' , 'id': ''};
  await Database.getcurret(user['id'], user['pseudo']);
  // creationg the doc of the grp
  DocumentReference ref = await _firestore.collection('Voyage').add({
    'nom': nom_grp,
    'admin': user['pseudo'],
    'destination': _destination,
    'membres': [
      user
    ], // since he's the admin, others have to accept the invitation first
  });

  Map grp = {'chemin': ref.path, 'nom': nom_grp};
  // adding that grp to member's invitations liste:
  for (String m in membres) {
    DocumentSnapshot doc =
        await Firestore.instance.collection('UserGrp').document(m).get();
    if (doc.exists) {
      if (doc.data.containsKey('invitations')) {
        doc.reference.updateData({
          'invitations': FieldValue.arrayUnion([grp])
        });
      } else {
        doc.reference.updateData({
          'invitations': [grp]
        });
      }
    } else {
      Firestore.instance.collection('UserGrp').document(m).setData({
        'pseudo': m,
        'invitations': [grp]
      });
    }
  }
  //adding it to admin list of grp
  await Firestore.instance
      .collection('UserGrp')
      .document(user['id'])
      .updateData({
    'groupes': FieldValue.arrayUnion([grp])
  });
}

class NvVoyagePage extends StatefulWidget {
  @override
  _NvVoyagePageState createState() => _NvVoyagePageState();
  static String id = 'nv_voyage';
}

class _NvVoyagePageState extends State<NvVoyagePage> {
  @override
  void initState() {
    membres = new List();
    _destination = 'votre destination';
    _controller = TextEditingController();
  }

  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Spacer(
              flex: 2,
            ),
            Center(
              child: Text(
                'Nouveau groupe',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff3B466B),
                ),
              ),
            ),
            Spacer(
              flex: 2,
            ),
            Container(
              height: 40,
              width: 350,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: primarycolor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    'vers ',
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '$_destination',
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() async {
                        _destination = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecherchePage()));
                      });
                    },
                    icon: Icon(Icons.mode_edit),
                    color: Color(0xff707070),
                    iconSize: 20,
                  ),
                ],
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Container(
              height: 43,
              width: 321,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color.fromRGBO(59, 70, 107, 0.3),
                    blurRadius: 7.0,
                    offset: Offset(0.0, 0.75),
                  )
                ],
              ),
              child: TextField(
                onTap: () {
                  setState(() {
                    _alerte_nom = false;
                  });
                },
                controller: _controller,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: '   Nom du groupe',
                  hintStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff707070),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _alerte_nom ? Colors.red : primarycolor,
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
            ),
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child: Text(
                '    Ajouter vos amis',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: _alerte_mbr ? Colors.red : Color(0xff707070),
                ),
              ),
            ),
            Container(
              width: 350,
              height: 250,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromRGBO(59, 70, 107, 0.3),
              ),
              child: FriendList((String membername) {
                membres.contains(membername)
                    ? membres.remove(membername)
                    : membres.add(membername);
                print(membres.toString());
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
                onPressed: () {
                  print(_controller.text);
                  print(membres.length);
                  setState(() {
                    if (_controller.text.isEmpty) {
                      _alerte_nom = true;
                    } else {
                      _alerte_nom = false;
                      nom_grp = _controller.text;
                    }
                    if (membres.isEmpty) {
                      _alerte_mbr = true;
                    } else {
                      _alerte_mbr = false;
                    }
                    if (nom_grp.isNotEmpty && membres.isNotEmpty) {
                      setState(() {
                        _loading = true;
                      });
                      createvoyage();
                      setState(() {
                        _loading = false;
                      });
                      Navigator.pushNamed(context, ListGrpPage.id);
                    }
                  });
                },
                child: Center(
                  child: Text(
                    'Créer',
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
            )
          ],
        ),
      ),
    );
  }
}
//----------------------------------------------------------------------------------//

class RecherchePage extends StatefulWidget {
  @override
  _RecherchePageState createState() => _RecherchePageState();
}

class _RecherchePageState extends State<RecherchePage> {
  @override
  Widget build(BuildContext context) {
    var _control = TextEditingController();
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _control,
              maxLines: 1,
            ),
            FlatButton(
              child: Text('ok'),
              onPressed: () {
                var txt = _control.text;
                Navigator.pop(context, txt);
              },
            ),
          ],
        ),
      ),
    );
  }
}
//----------------------------------------------------------------------------------//

class FriendList extends StatelessWidget {
  final Function _function;

  FriendList(this._function);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Utilisateur>>.value(
        value: data.friends,
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
    final friends = Provider.of<List<Utilisateur>>(context);
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
                _function(friends[index].pseudo);
              });
            },
            title: Text(
              friends[index].pseudo,
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
            trailing: membres.contains(friends[index].pseudo)
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
