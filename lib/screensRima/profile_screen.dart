import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:winek/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:winek/main.dart';

import '../classes.dart';

class ProfileScreen extends StatefulWidget {
  static const String id='profile';
  final Utilisateur myuser;

  ProfileScreen(this.myuser);
  @override
  _ProfileScreenState createState() => _ProfileScreenState(myuser);
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseUser loggedInUser;

  _ProfileScreenState(Utilisateur myuser);


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

          ),),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            child: Container(
              child: Center(
                  child: Image.network(widget.myuser.photo)
            ),
            )
        ),
      ),
    );
  }

/* SingleChildScrollView(

            child: Stack(
              children: <Widget>[

                Center(
                  child: Column(

                    children: <Widget>[
                      SizedBox(
                        height: 140,
                      ),
                      Container(
                        height: 500.0,
                        width: 320.0,
                      ),
                    ],),
                ),

                Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 140,
                      ),

                      Container( // carre principal
                        height: 400.0,
                        width: 320.0,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 70,),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 40.0, right: 30.0),
                              child: Text(
                                'hello',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff707070),
                                ),),),
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
                                ),),),
                            SizedBox(
                              height: 23,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 40.0, right: 30.0),
                              child: Text(
                                tel,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff000000),
                                ),),),
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
                                ),),),
                          ],),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey[300],
                            width: 3,),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.grey[200],
                              blurRadius: 20.0,),
                          ],
                          borderRadius: BorderRadius.circular(20),),
                      ),
                    ],
                  ),),


                Positioned(
                  top: 510,
                  right: 138,
                  left: 138,
                  bottom: 80,

                  child:
                  Container(
                    height: 200.0,
                    width: 30.0,
                    //Bouton ajoute

                    decoration: BoxDecoration(
                      color: Color(0xff389490),
                      border: Border.all(
                        color: Colors.grey[300],
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),),

                Center(
                  child: Column( //photos


                    children: <Widget>[
                      SizedBox(
                        height: 90,
                      ),
                      Container(
                        height: 110.0,
                        width: 110.0,

                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey[300],
                            width: 3,),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.grey[200],
                              blurRadius: 20.0,),
                          ],
                        ),
                        child: photoWig(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),*/
  Widget photoWig() {
    if (photo != null) {
      return Center(
        child: Image(image: NetworkImage(photo)),
      );
    }
    else {
      return
        Center(
          child:
          ListView( //photos
            children: <Widget>[
              SizedBox(
                height: 16,),
              Icon(
                Icons.person,
                color: Color(0xFF5B5050),
                size: 105.0,
              ),
            ],),);
    }
  }

  bool isEditable = false;

  _edit() {
    setState(() {
      isEditable = true;
      print(isEditable);
    });
  }

  String accountStatus = '******';
  FirebaseUser result;


  TextEditingController pseudoInputController;

  TextEditingController telInputController;
  TextEditingController mdpInputController;

  @override
  initState() {
    pseudoInputController = new TextEditingController();
    telInputController = new TextEditingController();
    mdpInputController = new TextEditingController();

    super.initState();
    getData();
    print('here outside async');
  }

  String mail, pseudo, tel, photo;

  Future userID;


  Future getData() async {
    print('getdatadebut');
    var id = await authService.connectedID();

    await authService.db.collection('Utilisateur').document(id).get().then((
        docSnap) {
      if (docSnap != null) {
        pseudo = docSnap.data['pseudo'];
      }


      print('gonna print the onvalue ');
      print(docSnap);
      print('printed the onvalue ');

      authService.userRef.document(docSnap).snapshots()
          .listen((data) {
        data.documents.forEach((doc) {
          setState(() {
            data.documents.forEach((doc) {
              setState(() {
                mail = doc.data['mail'];
                print('mail');
                print(mail);
                tel = doc.data['tel'];
                print('tel');

                print(tel);
                pseudo = doc.data['pseudo'];
                print('pseudo');

                print(pseudo);
                photo = doc.data['photo'];
                print('photo');

                print(photo);
              });
            });
          });
        });
      });
      /*var us = authService.db.collection('Utilisateur').document(ref).snapshots().map((val) {
      Utilisateur.fromMap(val);
      setState(() {
        mail = val.data['mail'] ;
        pseudo = val.data['pseudo'] ;
        tel= val.data['tel'];
        photo =  val.data['photo'] ;
      });
    });*/

      // print(us.toString());
      print('getdatafin');
    });
  }
/*
 Container (
          child : FutureBuilder(
              future:  authService.userRef.document(authService.connectedID()),
              builder: (context ,snapshot){
                switch (snapshot.connectionState){
                  case ConnectionState.none: return Center(child: Text('not connected please retry')) ;
                   case ConnectionState.active: return Center(
                     child: SpinKitChasingDots(
                       // ignore: missing_return
                       color: Color(0XFF389490),//vert
                     ),
                   );
                    break;
                  case ConnectionState.done :
                  default:
                }
              },
          )
*/

/*_showDialog() async {
  await showDialog<String>(
    context: context,
    child: AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: Column(
          children: <Widget>[
          Text("Please fill all fields to create a new task"),
      Expanded(
        child: TextField(
          autofocus: true,
          decoration: InputDecoration(labelText: 'pseudo'),
          controller: pseudoInputController,
        ),
      ),
      Expanded(
        child: TextField(
          decoration: InputDecoration(labelText: 'telephone'),
            controller: telInputController,
          ),
        ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'mot de passe'),
                controller: mdpInputController,
              ),
            ),

          ],
      ),
      actions: <Widget>[
        FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              pseudoInputController.clear();
              telInputController.clear();
              mdpInputController.clear();

              Navigator.pop(context);
            }),
        FlatButton(
            child: Text('Changer'),
            onPressed: () {
              if (pseudoInputController.text.isNotEmpty &&
                  telInputController.text.isNotEmpty  &&
                  mdpInputController.text.isNotEmpty) {
                authService.db.collection('Utilisateur').document('liste'){
                  "pseudo": pseudoInputController.text,
                  "tel": telInputController.text,
                  "mot de passe": mdpInputController.text,
                })
                    .then((result) => {
                  Navigator.pop(context),
                  pseudoInputController.clear(),
                  telInputController.clear(),
                  mdpInputController.clear(),

                })
                    .catchError((err) => print(err));
              }
            })
      ],
    ),
  );
} */


/* void updateData() {
    // a verifier ????
    try {
      authService.db
          .collection('Utilisateur').document(
          'Utilisateur/${authService.loggedIn}')
          .updateData({'description': 'Head First Flutter'});
    } catch (e) {
      print(e.toString());
    }
  }


}


Padding(
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
                        color: Colors.red,
                        height: 500.0,
                        width: 320.0,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 140,
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
                                user.pseudo.toString(),
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
                                'pseudo',
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
                                'tel' ,
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
                                'mail' ,
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

                Center(
                  child: Column(
                    //photos

                    children: <Widget>[
                      SizedBox(
                        height: 90,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ), */
}