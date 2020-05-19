import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winek/main.dart';
import '../dataBaseSoum.dart';
import 'usersListScreen.dart';
import 'package:winek/auth.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/widgets.dart';


final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class ProfileScreen2 extends StatefulWidget {
  static const String id = 'profile';
  final String pseudo;
  final String currentUser;
  final Map friend;

  final String name;

  const ProfileScreen2({this.friend, this.pseudo, this.currentUser, this.name});

  @override
  _ProfileScreen2State createState() => _ProfileScreen2State(
      friend: friend, pseudo: pseudo, currentUser: currentUser, name: name);
}

class _ProfileScreen2State extends State<ProfileScreen2> {
  String pseudo;

  String currentUser;
  bool ami = false;
  bool amipseudo = false;
  String online = 'online';
  String who = '';
  String mail = 'marche pas';
  String phone = 'marche pas';
  String image;
  double size;
  String id;
  Map friend;
  bool tap = true;

  String currentName;

  bool invit = false;

  final CollectionReference userCollection =
  Firestore.instance.collection('Utilisateur');

  _ProfileScreen2State(
      {Map friend, String pseudo, String currentUser, String name}) {
    this.pseudo = pseudo != null ? pseudo : friend['pseudo'];
    this.currentUser = currentUser;

    size = 102;
    userCollection
        .where("pseudo", isEqualTo: this.pseudo)
        .snapshots()
        .listen((data) {
      //    data.documents.forEach((doc) {
      for (var doc in data.documents) {
        if (mounted) {
          setState(() {
          this.id = doc.documentID;
          if (doc.data['connecte'] == true) {
            online = 'En ligne';
          } else {
            online = 'Hors ligne';
          }
          });
        }
      } //);
    });

    this.currentName = name;


    Firestore.instance
        .collection('Utilisateur')
        .where("pseudo", isEqualTo: this.pseudo)
        .snapshots()
        .listen((data) {
      // data.documents.forEach((doc) {
      for (var doc in data.documents) {
        if (mounted) {
          setState(() {
          mail = doc.data['mail'];
          phone = doc.data['tel'];
          if (phone == null) {
            phone = 'aucun numero';
          }
        });
        }
      } //);
    });
  }

  @override
  void initState() {
    super.initState();

    userCollection
        .document(currentUser) // id du doc
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.data["invitation "].contains(pseudo)) {
        setState(() {
          invit = true;
        });
      }
    });

    if (!invit) {
      userCollection
          .document(currentUser) // id du doc
          .get()
          .then((DocumentSnapshot doc) {
        List<dynamic> friendcurrent = doc.data["amis"];
        if (friendcurrent != null) {
          for (var map in friendcurrent) {
            if (map["id"] == this.id) {
              setState(() {
                who = 'Supprimer';
                size = responsivewidth(100);
                ami = true;
              });
            }
          }
        }

        if (!ami) {
          Firestore.instance
              .collection('Utilisateur')
              .where("pseudo", isEqualTo: pseudo)
              .limit(1)
              .snapshots()
              .listen((data) {
            // var doc = data.document;
            // data.documents.forEach((doc) {
            for (var doc in data.documents) {
              List<dynamic> friendpseudo = doc.data["amis"];
              if (friendpseudo != null) {
                for (var map in friendpseudo) {
                  if (map["id"] == currentUser) {
                    setState(() {
                      who = 'Supprimer';
                      size = responsivewidth(100);
                      amipseudo = true;
                    });
                  }
                }
              }
              if (doc.data["invitation "].contains(currentName)) // amis*
                  {
                if (mounted) {
                  setState(() {
                  who = 'Annuler l\'invitaion';
                  size = responsivewidth(80);
                  });
                }
              } else if (!amipseudo &&
                  !doc.data["invitation "].contains(currentName)) {
                if (mounted) {
                  setState(() {
                  who = 'Ajouter';
                  size = responsivewidth(100);
                  });
                }
              }
            }
          });
        }
      });
    }

    userCollection
        .where("pseudo", isEqualTo: currentName)
        .limit(1)
        .snapshots()
        .listen((data) {
      // data.documentChanges.forEach((change) {
      for (var change in data.documentChanges) {
        if (change != null) {
          if (!change.document.data["invitation "].contains(pseudo)) {
            if (mounted) {
              setState(() {
                invit = false;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                invit = true;
              });
            }
          }
        }
      } //);
    });
    if (!invit) { //todo
      Firestore.instance
          .collection('Utilisateur')
          .where("pseudo", isEqualTo: currentName)
          .limit(1)
          .snapshots()
          .listen((data) {
        //   data.documentChanges.forEach((change) {
        for (var change in data.documentChanges) {
          ami = false;
          if (change != null) {
            List<dynamic> friendcurrent = change.document.data["amis"];
            if (friendcurrent != null) {
              for (var map in friendcurrent) {
                if (map["id"] == this.id) {
                  if (mounted) {
                    setState(() {
                      who = 'Supprimer';
                      size = responsivewidth(100);
                      ami = true;
                    });
                  }
                }
              }
            }

            if (!ami) {
              Firestore.instance
                  .collection('Utilisateur')
                  .where("pseudo", isEqualTo: pseudo)
              //  .limit(1)
                  .snapshots()
                  .listen((data) {
                //   data.documentChanges.forEach((changes) {
                for (var changes in data.documentChanges) {
                  if (changes != null) {
                    amipseudo = false;
                    List<dynamic> friendpseudo = changes.document.data["amis"];
                    if (friendpseudo != null) {
                      for (var map in friendpseudo) {
                        if (map["id"] == currentUser) {
                          if (mounted) {
                            setState(() {
                              who = 'Supprimer';
                              size = responsivewidth(100);
                              amipseudo = true;
                            });
                          }
                        }
                      }
                    }

                    if (changes.document.data["invitation "]
                        .contains(currentName)) // amis*
                        {
                      if (mounted) {
                        setState(() {
                          who = 'Annuler l\'invitaion';
                          size = responsivewidth(100);
                        });
                      }
                    } else if (!amipseudo &&
                        !changes.document.data["invitation "]
                            .contains(currentName)) {
                      if (mounted) {
                        setState(() {
                          who = 'Ajouter';
                          size = responsivewidth(100);
                        });
                      }
                    }
                  }
                } //);
              });
            } //fin else
          }
        } //);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  _showSnackBar(String value, BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
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

    ));
  }


  Widget getButton() {

    if (pseudo == currentName) {
      return Container();
    }
    if (invit) {
      return Positioned(
        top: responsiveheight(470),
        right: responsivewidth(80),
        left: responsivewidth(80),
        bottom: responsiveheight(50),
        child: Container(
          height: responsiveheight(200.0),
          width: responsivewidth(200.0),
          child: Wrap(
            children: <Widget>[
              MaterialButton(
                child: Center(
                  child: Text(
                    '$pseudo vous a envoyé une invitation',
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: responsivetext(18),
                      fontWeight: FontWeight.w600,
                      color: Color(0xff707070),
                    ),
                  ),
                ),),
              Row(
                children: <Widget>[

                  Flexible(child: Container(
                    height: responsiveheight(40.0),
                    width: responsivewidth(110.0),
                    child: MaterialButton(
                        child: Center(
                          child: Text(
                            'Accepter',
                            style: TextStyle(
                              fontFamily: 'montserrat',
                              fontSize: responsivetext(14),
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),),
                        onPressed: () async {
                          try {
                            final result = await InternetAddress.lookup(
                                'google.com');
                            var result2 = await Connectivity()
                                .checkConnectivity();
                            var b = (result2 != ConnectivityResult.none);

                            if (b && result.isNotEmpty &&
                                result[0].rawAddress.isNotEmpty) {
                              if (tap) {
                                setState(() {
                                  tap = false;
                                });
                                Database d = await Database().init(
                                    pseudo: pseudo,
                                    subipseudo: currentName,
                                    currentid: currentUser);
                                await d.userUpdateData();
                                Database c = await Database().init(
                                    id: currentUser,
                                    subipseudo: pseudo,
                                    currentid: currentUser);
                                await c.userUpdateData();
                                await Database(pseudo: pseudo)
                                    .userDeleteData(currentUser);
                                setState(() {
                                  invit = false;
                                  size = responsivewidth(100);
                                  who = "Supprimer";
                                  tap = true;
                                });
                                _showSnackBar(
                                    'vous et $pseudo êtes désormais amis!',
                                    context);
                              }
                            }
                          } on SocketException catch (_) {
                            _showSnackBar(
                                'Vérifiez votre connexion internet', context);
                          }
                        }),
                    decoration: BoxDecoration(
                      color: Color(0xff389490),
                      border: Border.all(
                        color: Color(0xff389490),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(
                          responsiveradius(20, 1)),
                    ),
                  ),),
                  SizedBox(
                    width: responsivewidth(10),
                  ),
                  Flexible(child: Container(
                    height: responsiveheight(40.0),
                    width: responsivewidth(110.0),
                    child: MaterialButton(
                        child: Center(
                          child: Text(
                            'Refuser',
                            style: TextStyle(
                              fontFamily: 'montserrat',
                              fontSize: responsivetext(14),
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),),
                        onPressed: () async {
                          try {
                            final result = await InternetAddress.lookup(
                                'google.com');
                            var result2 = await Connectivity()
                                .checkConnectivity();
                            var b = (result2 != ConnectivityResult.none);

                            if (b && result.isNotEmpty &&
                                result[0].rawAddress.isNotEmpty) {
                              if (tap) {
                                setState(() {
                                  tap = false;
                                });
                                await Database(pseudo: pseudo).userDeleteData(
                                    currentUser);
                                setState(() {
                                  invit = false;
                                  size = responsivewidth(100);
                                  who = "Ajouter";
                                  tap = true;
                                });
                                _showSnackBar(
                                    'Invitation supprimée !', context);
                              }
                            }
                          } on SocketException catch (_) {
                            _showSnackBar(
                                'Vérifiez votre connexion internet', context);
                          }
                        }),
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      border: Border.all(
                        color: Colors.red[400],
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(
                          responsiveradius(20, 1)),
                    ),
                  ),),
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey[300],
              width: 3,
            ),
            borderRadius: BorderRadius.circular(responsiveradius(20, 1)),
          ),
        ),
      );
    } else {
      return Positioned(
        top: responsiveheight(495),
        right: responsivewidth(size),
        left: responsivewidth(size),
        bottom: responsiveheight(76),
        child: Container(
          height: responsiveheight(200.0),
          width: responsivewidth(30.0),
          //Bouton ajouter
          child: MaterialButton(
            child: Center(
              child: Text(
                who,
                style: TextStyle(
                  fontFamily: 'montserrat',
                  fontSize: responsivetext(17),
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),),
            onPressed: () async {
              try {
                final result = await InternetAddress.lookup('google.com');
                var result2 = await Connectivity().checkConnectivity();
                var b = (result2 != ConnectivityResult.none);

                if (b && result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  if (tap) {
                    setState(() {
                      tap = false;
                    });

                    if (who == "Ajouter") {
                      await Database(pseudo: currentName).invitUpdateData(id);
                      //envoyer invit
                      setState(() {
                        who = "Annuler l\'invitaion";
                        size = responsivewidth(80);
                        tap = true;
                      });

                      _showSnackBar('Invitation envoyée !', context);
                    } else {
                      if (who == 'Annuler l\'invitaion') {
                        await Database(pseudo: currentName).userDeleteData(id);
                        setState(() {
                          who = "Ajouter";
                          size = responsivewidth(100);
                          tap = true;
                        });
                        _showSnackBar('Invitation annulée!', context);
                      } else {
                        // if who=supprimer

                        await Database(pseudo: pseudo).friendDeleteData(currentUser);
                        await Database(pseudo: currentName).friendDeleteData(id);
                        setState(() {
                          who = "Ajouter";
                          size = responsivewidth(100);
                          tap = true;
                        });
                      }
                      _showSnackBar('Ami supprimé !', context);
                    }
                  }
                }
              } on SocketException catch (_) {
                _showSnackBar('Vérifiez votre connexion internet', context);
              }
            },
          ),

          decoration: BoxDecoration(
            color: Color(0xff389490),
            border: Border.all(
              color: Colors.grey[300],
              width: 3,
            ),
            borderRadius: BorderRadius.circular(responsiveradius(20, 1)),
          ),
        ),
      );
    }
  }

  Widget photo() {
    Firestore.instance
        .collection('Utilisateur')
        .where("pseudo", isEqualTo: pseudo)
        .limit(1)
        .snapshots()
        .listen((data) {
      //data.documents.forEach((doc) {
      for (var doc in data.documents) {
        image = doc.data['photo'];
      } //);
    });
    if (image != null) {
      return Center(
        child: FittedBox(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(responsiveradius(18, 1)),
              child: Image(image: NetworkImage(image))),
          fit: BoxFit.fill,
        ),
      );
    } else {
      return Center(
        child: ListView(
          //photos
          children: <Widget>[
            SizedBox(
              height: responsiveheight(16),
            ),
            Icon(
              Icons.person,
              color: Color(0xFF5B5050),
              size: responsivewidth(105.0),
            ),
          ],
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(28.0),
          child: AppBar(
            backgroundColor: Colors.white30,
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Colors.black54,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(

                        height: responsiveheight(140),
                      ),
                      Container(
                        height: responsiveheight(480.0),
                        width: responsivewidth(320.0),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: responsiveheight(120),
                      ),
                      Container(
                        // carre principal

                        height: responsiveheight(400.0),
                        width: responsivewidth(320.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: responsiveheight(70),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: responsivewidth(40.0),
                                  right: responsivewidth(30.0)),
                              child: FittedBox(fit: BoxFit.fitWidth,
                                child: Text(
                                  online,
                                  style: TextStyle(
                                    fontSize: responsivetext(16),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff707070),
                                  ),
                                ),
                              ),),
                            SizedBox(
                              height: responsiveheight(26),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: responsivewidth(40.0),
                                  right: responsivewidth(30.0)),
                              child: FittedBox(fit: BoxFit.fitWidth,
                                child: Text(
                                  pseudo,
                                  style: TextStyle(
                                    fontSize: responsivetext(28),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ),),
                            SizedBox(
                              height: responsiveheight(23),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: responsivewidth(40.0),
                                  right: responsivewidth(30.0)),
                              child: FittedBox(fit: BoxFit.fitWidth,
                                child: Text(
                                  phone,
                                  style: TextStyle(
                                    fontSize: responsivetext(16),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ),),
                            SizedBox(
                              height: responsiveheight(23),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: responsivewidth(40.0),
                                  right: responsivewidth(30.0)),
                              child: FittedBox(fit: BoxFit.fitWidth,
                                child: Text(
                                  mail,
                                  style: TextStyle(
                                    fontSize: responsivetext(16),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ),),
                          ],
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey[300],
                            width: 3,
                          ),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.grey[200],
                              blurRadius: responsiveradius(20.0, 1),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(responsiveradius(
                              20, 1)),
                        ),
                      ),
                    ],
                  ),
                ),
                getButton(),
                Center(
                  child: Column(
                    //photos

                    children: <Widget>[
                      SizedBox(
                        height: responsiveheight(65),
                      ),
                      Container(
                          height: responsivewidth(110.0),
                          width: responsivewidth(110.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey[300],
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(
                                responsiveradius(20, 1)),
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.grey[200],
                                blurRadius: responsiveradius(20.0, 1),
                              ),
                            ],
                          ),
                          child: photo()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
