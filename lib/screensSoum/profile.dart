import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../dataBaseSoum.dart';
import 'usersListScreen.dart';
import 'package:winek/auth.dart';

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

  String currentName;

  bool invit = false;

  final CollectionReference userCollection =
      Firestore.instance.collection('Utilisateur');

  _ProfileScreen2State(
      {Map friend, String pseudo, String currentUser, String name}) {
    this.pseudo = pseudo != null ? pseudo : friend['pseudo'];
    this.currentUser = currentUser;

    size = 102;
    print('hellooooooooooooo');
    userCollection
        .where("pseudo", isEqualTo: this.pseudo)
        .snapshots()
        .listen((data) {
      data.documents.forEach((doc) {
        setState(() {
          this.id = doc.documentID;
          if (doc.data['connecte'] == true) {
            online = 'En ligne';
          } else {
            online = 'Hors ligne';
          }
          print(id);
        });
      });
    });

    this.currentName = name;

    print('currentuuuuuuuuuuuuuserrr $currentUser');
    print('currrrrentnnnnaaaameeeeeeeee  $currentName');

    Firestore.instance
        .collection('Utilisateur')
        .where("pseudo", isEqualTo: this.pseudo)
        .snapshots()
        .listen((data) {
      data.documents.forEach((doc) {
        print('heeeeere');
        print(this.pseudo);
        setState(() {
          mail = doc.data['mail'];
          phone = doc.data['tel'];
        });
      });
    });

    /* userCollection.document(this.id)
        .get()
        .then((DocumentSnapshot data) {
        setState(() {
          mail=data.data['mail'];
          phone=data.data['tel']; });});*/

    /*userCollection.document(id).get().then((docSnap) {
      mail=docSnap.data['mail'];
      phone=docSnap.data['tel'];});*/
    /* Firestore.instance
        .collection('Utilisateur')
        .where("pseudo", isEqualTo: id)
        .snapshots()
        .listen((data) {
      data.documents.forEach((doc) {
        setState(() {
          mail=doc.data['mail'];
          phone=doc.data['tel']; });
      }
      );});*/
  }

  @override
  void initState() {
    super.initState();

    print('Initstateeeeeee');

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
                size = 138;
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
            data.documents.forEach((doc) {
              List<dynamic> friendpseudo = doc.data["amis"];
              if (friendpseudo != null) {
                for (var map in friendpseudo) {
                  if (map["id"] == currentUser) {
                    setState(() {
                      who = 'Supprimer';
                      size = 138;
                      amipseudo = true;
                    });
                  }
                }
              }
              if (doc.data["invitation "].contains(currentName)) // amis*
              {
                setState(() {
                  who = 'Annuler l\'invitaion';
                  size = 102;
                });
              } else if (!amipseudo &&
                  !doc.data["invitation "].contains(currentName)) {
                setState(() {
                  who = 'Ajouter';
                  size = 138;
                });
              }
            });
          });
        }
      });
    }

    userCollection
        .where("pseudo", isEqualTo: currentName)
        .limit(1)
        .snapshots()
        .listen((data) {
      data.documentChanges.forEach((change) {
        if (!change.document.data["invitation "].contains(pseudo)) {
          setState(() {
            invit = false;
          });
        } else {
          setState(() {
            invit = true;
          });
        }
      });
    });
    if (!invit) {
      Firestore.instance
          .collection('Utilisateur')
          .where("pseudo", isEqualTo: currentName)
          .limit(1)
          .snapshots()
          .listen((data) {
        data.documentChanges.forEach((change) {
          ami = false;
          List<dynamic> friendcurrent = change.document.data["amis"];
          if (friendcurrent != null) {
            for (var map in friendcurrent) {
              if (map["id"] == this.id) {
                setState(() {
                  who = 'Supprimer';
                  size = 138;
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
              data.documentChanges.forEach((change) {
                amipseudo = false;
                List<dynamic> friendpseudo = change.document.data["amis"];
                if (friendpseudo != null) {
                  for (var map in friendpseudo) {
                    if (map["id"] == currentUser) {
                      setState(() {
                        who = 'Supprimer';
                        size = 138;
                        amipseudo = true;
                      });
                    }
                  }
                }

                if (change.document.data["invitation "]
                    .contains(currentName)) // amis*
                {
                  print('annuuule invit');
                  setState(() {
                    who = 'Annuler l\'invitaion';
                    size = 102;
                  });
                } else if (!amipseudo &&
                    !change.document.data["invitation "]
                        .contains(currentName)) {
                  print('ajouuuut');
                  setState(() {
                    who = 'Ajouter';
                    size = 138;
                  });
                }
              });
            });
          } //fin else
        });
      });
    }
  }

  Widget getButton() {
    if (pseudo == currentName) {
      return Container();
    }
    if (invit) {
      return Positioned(
        top: 470,
        right: 80,
        left: 80,
        bottom: 50,
        child: Container(
          height: 200.0,
          width: 200.0,
          child: Column(
            children: <Widget>[
              MaterialButton(
                child: Center(
                  child: Text(
                    '$pseudo vous a envoyé une invitation',
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff707070),
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    height: 40.0,
                    width: 110.0,
                    child: MaterialButton(
                        child: Center(
                          child: Text(
                            'Accepter',
                            style: TextStyle(
                              fontFamily: 'montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () async {
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
                            size = 138;
                            who = "Supprimer";
                          });
                        }),
                    decoration: BoxDecoration(
                      color: Color(0xff389490),
                      border: Border.all(
                        color: Color(0xff389490),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 40.0,
                    width: 110.0,
                    child: MaterialButton(
                        child: Center(
                          child: Text(
                            'Refuser',
                            style: TextStyle(
                              fontFamily: 'montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await Database(pseudo: pseudo)
                              .userDeleteData(currentUser);
                          setState(() {
                            invit = false;
                            size = 138;
                            who = "Ajouter";
                          });
                        }),
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      border: Border.all(
                        color: Colors.red[400],
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
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
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    } else {
      return Positioned(
        top: 495,
        right: size,
        left: size,
        bottom: 76,
        child: Container(
          height: 200.0,
          width: 30.0,
          //Bouton ajouter
          child: MaterialButton(
            child: Center(
              child: Text(
                who,
                style: TextStyle(
                  fontFamily: 'montserrat',
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            onPressed: () async {
              if (who == "Ajouter") {
                //envoyer invit
                setState(() {
                  who = "Annuler l\'invitaion";
                  size = 102;
                });
                await Database(pseudo: currentName).invitUpdateData(id);
              } else {
                if (who == 'Annuler l\'invitaion') {
                  setState(() {
                    who = "Ajouter";
                    size = 138;
                  });
                  await Database(pseudo: currentName).userDeleteData(id);
                } else {
                  // if who=supprimer

                  await Database(pseudo: pseudo).friendDeleteData(currentUser);
                  await Database(pseudo: currentName).friendDeleteData(id);
                  setState(() {
                    who = "Ajouter";
                    size = 138;
                  });
                  // ami=false ;
                  // amipseudo=false;

                }
              }
            },
          ),

          decoration: BoxDecoration(
            color: Color(0xff389490),
            border: Border.all(
              color: Colors.grey[300],
              width: 3,
            ),
            borderRadius: BorderRadius.circular(20),
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
      data.documents.forEach((doc) {
        image = doc.data['photo'];
      });
    });
    if (image != null) {
      return Center(
        child: FittedBox(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
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
              height: 16,
            ),
            Icon(
              Icons.person,
              color: Color(0xFF5B5050),
              size: 105.0,
            ),
          ],
        ),
      );
    }
  }

  /*Future<Null> checkForChanges() async {//voir si linvit a été accepté

    Firestore.instance
        .collection('Utilisateur')
        .where("pseudo", isEqualTo: currentUser)
        .limit(1)
        .snapshots()
        .listen((data) {
      data.documentChanges.forEach((change) {
        if ( change.document.data["amis"].contains(id))
        {setState(() {
          who='Supprimer'; });
        }
        else{
          Firestore.instance
              .collection('Utilisateur')
              .where("pseudo", isEqualTo: id)
              .limit(1)
              .snapshots()
              .listen((data) {
            data.documentChanges.forEach((change) {
              setState(() {
                if ( change.document.data["invitation"].contains(currentUser))// amis*
                    {setState(() {who='Annuler l\'invitaion';});}
                else {setState(() {who='Ajouter';});} });}
            );});}//fin else
      });});}*/

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                        height: 140,
                      ),
                      Container(
                        height: 480.0,
                        width: 320.0,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 120,
                      ),
                      Container(
                        // carre principal
                        height: 400.0,
                        width: 320.0,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 70,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 40.0, right: 30.0),
                              child: Text(
                                online,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff707070),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 26,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 40.0, right: 30.0),
                              child: Text(
                                pseudo,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 23,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 40.0, right: 30.0),
                              child: Text(
                                phone,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 23,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 40.0, right: 30.0),
                              child: Text(
                                mail,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
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
                              blurRadius: 20.0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
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
                        height: 60,
                      ),
                      Container(
                          height: 110.0,
                          width: 110.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey[300],
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.grey[200],
                                blurRadius: 20.0,
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
