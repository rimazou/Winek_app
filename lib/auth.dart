import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:winek/dataBaseSoum.dart';
import 'classes.dart';


class AuthService extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
 StreamSubscription<Position> positionStream ;
  Geoflutterfire geo = Geoflutterfire();
  FirebaseUser _loggedIn;

  get userRef => _db.collection('Utilisateur');

  FirebaseUser get loggedIn => _loggedIn;

  /* _signInG() async {
    try{
      await _googleSignIn.signIn();
      GoogleSignInAccount googleUser = await _googleSignIn.signIn() ;
      GoogleSignInAuthentication googleAuth = await googleUser.authentication ;
      FirebaseUser user = await _auth.signInWithGoogle(
        accessToken
      )
      setState(() {
        _isLoggedin=true ;
        print('vous etes connecte');
      })
    }
    catch(err){
      print(err);
    };*/ //on doit avoir stateful widget

  /* _signOutG() async {
      try{
        await _googleSignIn.signOut();

      }
      catch(err){
        print(err);
      }
  }
*/
  GoogleSignIn get googleSignIn => _googleSignIn;

  Firestore get db => _db;

  FirebaseAuth get auth => _auth;

  set loggedIn(FirebaseUser value) {
    _loggedIn = value;
  }

  Utilisateur toUtil() {
    loggedIn = auth.currentUser() as FirebaseUser;
    return Utilisateur(
      pseudo: loggedIn.uid,
      tel: loggedIn.phoneNumber,
      mail: loggedIn.email,
    );
  }

  getUser(String idDoc) {
    return Firestore.instance
        .collection('Utilisateur')
        .document(idDoc)
        .snapshots();
  }

  /*Future <String> connectedID() async {
    // returns null when no user is logged in
    // print('stratConnectedid');
    auth.currentUser().then((onValue) {
      //  print(onValue.email);
      print(onValue.uid);
      // print('endConnectedid');
      return onValue.uid;
    }).catchError((onError) {
      //   print('caught error connectedID') ;
      //   print(onError);
      print('means none connected');
    });
  }*/
  Future<String> connectedID() async {
    final FirebaseUser user = await auth.currentUser();
    if (user == null) {
      print('no user connected'); // dans ce cas connectedID retourne null
    } else {
      print(user.uid);
      print(user.email);
      return user.uid;
    }
  }

  Future<String> getPseudo(String id) async {
    String name = 'marche pas';
    await authService.db
        .collection('Utilisateur')
        .document(id)
        .get()
        .then((docSnap) {
      if (docSnap != null) {
        name = docSnap.data['pseudo'];
      }
    });
    return name;
  }

  Future sendPwdResetEmail(String email) async {
    try {
      final reset = _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> isLog() async {
    // returns false when no user is logged in
    var ui = await connectedID();
    if (ui == null) {
      return false;
    } else {
      return true;
    }
  }

  void getUserLocation() async {
    var val = await connectedID();
    if (val !=
        null) // ca permetra de faire lappel seulement quand le user est co
    {
      try {
        var geolocator = Geolocator();
        Position position;
        var locationOptions =
            LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
         positionStream =
            geolocator.getPositionStream(locationOptions).listen((position) {
          double vitesse = position.speed;
          GeoFirePoint geoFirePoint = authService.geo.point(
              latitude: position.latitude, longitude: position.longitude);
          authService.userRef
              .document(val)
              .updateData({'location': geoFirePoint.data, 'vitesse': vitesse});
          print(geoFirePoint.data.toString());
        });
      } catch (e) {
        print('ya eu une erreur pour la localisation');
      }
    }
  }

  void updategroupelocation() async {
    String id = await connectedID();
    DocumentSnapshot querySnapshot =
        await Firestore.instance.collection('UserGrp').document(id).get();
    List<Map<dynamic, dynamic>> groupes = List();
    print(querySnapshot.data.toString());
    if (querySnapshot.exists && querySnapshot.data.containsKey('groupes')) {
      groupes = List<Map<dynamic, dynamic>>.from(querySnapshot.data['groupes']);
    }
    if (groupes.isNotEmpty) {
      GeoPoint position;
      GeoFirePoint geoFirePoint;
//  Geoflutterfire geo = Geoflutterfire();
      Firestore.instance
          .collection('Utilisateur')
          .document(id)
          .snapshots(includeMetadataChanges: true)
          .listen((DocumentSnapshot documentSnapshot) {
        position = documentSnapshot.data['location']['geopoint'];
        geoFirePoint = geo.point(
            latitude: position.latitude, longitude: position.longitude);
        for (Map grp in groupes) {
          Firestore.instance
              .document(grp['chemin'])
              .collection('members')
              .document(id)
              .updateData({'position': geoFirePoint.data});
        }
      });
    }
  }

  Future<FirebaseUser> getLoggedFirebaseUser() {
    return auth.currentUser();
  }

  Future<bool> updategroupemembers(
      String ref, String mpseudo, String mid) async {
    Map membre = {'pseudo': mpseudo, 'id': mid};
    bool exist = false;
    DocumentReference groupesReference = Firestore.instance.document(ref);
    return Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(groupesReference);
      if (postSnapshot.exists) {
        // that grp exist
        for (var map in postSnapshot.data['membres']) {
          if (map['id'] == mid) {
            exist = true;
            await tx.update(groupesReference, <String, dynamic>{
              'membres': FieldValue.arrayRemove([membre])
            });
            // if its already there, we're gonna delete it:
          }
        }
        if (!exist) {
          await tx.update(groupesReference, <String, dynamic>{
            'membres': FieldValue.arrayUnion([membre])
          });
        }
      }
    }).then((result) {
      return true;
    }).catchError((error) {
      print('Error: $error');
      return false;
    });
  }

  final CollectionReference userCollection =
      Firestore.instance.collection('Utilisateur');

  Future<String> getID(String pseudo) async {
    String id;
    await userCollection.getDocuments().then((QuerySnapshot data) {
      data.documents.forEach((doc) {
        if (doc.data['pseudo'] == pseudo) id = doc.documentID;
      });
    });
    print(id);
    return id.toString();
  }

  Future<Null> changePseudo(String oldp, String newp) async {
    String id = await getID(oldp);
    Map fellow = {'pseudo': oldp, 'id': id};
    await userCollection.getDocuments().then((QuerySnapshot data) {
      data.documents.forEach((doc) async {
        if (doc.data['pseudo'] == oldp) {
          await userCollection
              .document(doc.documentID)
              .updateData({'pseudo': newp});
        } else {
          List<dynamic> list =
              doc.data['amis']; // Liste amiiiiiiiiiiiiiiiiiiiiiiiis
          if (list != null) {
            for (var map in list) {
              if (map['id'] == id) {
                await Database(pseudo: oldp).friendDeleteData(doc.documentID);
                Database d = await Database()
                    .init(pseudo: newp, id: id, subipseudo: doc.data['pseudo']);
                await d.userUpdateData();
              }
            }
          }
          List<dynamic> listinvit =
              doc.data['invitation ']; //Liste inviiiiiiiiiiiiiiiiiiiit
          if (listinvit != null) {
            if (listinvit.contains(oldp)) {
              await Database(pseudo: oldp).userDeleteData(doc.documentID);
              await Database(pseudo: newp).invitUpdateData(doc.documentID);
            }
          }
        }
      });
    }); //**************
    await authService.db
        .collection('UserGrp')
        .getDocuments()
        .then((QuerySnapshot data) {
      data.documents.forEach((doc) async {});
    });
    await db
        .collection('UserGrp')
        .document(id)
        .get()
        .then((DocumentSnapshot doc) async {
      if (doc.data['pseudo'] == oldp) // Update le pseudo de UserGrp
      {
        await db
            .collection('UserGrp')
            .document(id)
            .updateData({'pseudo': newp});
      }

      List<dynamic> groupes = doc.data['groupes'];
      for (var map in groupes) {
        // On parcourrrs tout les grouuuuuuupes
        String grp = map["chemin"];

        await db.document(grp).get().then((DocumentSnapshot data) async {
          if (data.data['admin'] == oldp) // Admiiiiiiiiiiiiiiiiiiiiin
          {
            await authService.db.document(grp).updateData({'admin': newp});
          }

          List<dynamic> membres = List.from(data.data['membres']);
          if (membres != null) {
            for (var map in membres) {
              if (map['id'] == id) {
                await updategroupemembers(grp, oldp, id);
                await updategroupemembers(grp, newp, id);
              }
            }
          }

          try {
            // Sennnnnnderrrrrrrrrrr
            await db
                .document(grp)
                .collection('receivedAlerts')
                .getDocuments()
                .then((QuerySnapshot data) {
              if (data != null)
                data.documents.forEach((doc) async {
                  if (doc != null) {
                    if (doc.data['sender'] == oldp) {
                      await doc.reference.updateData({'sender': newp});
                    }
                  }
                });
            });
          } catch (e) {
            print(e.toString());
          }
        });
      } // Fin foooooooooooooooooor
    });
  }
}

final AuthService authService = AuthService();
