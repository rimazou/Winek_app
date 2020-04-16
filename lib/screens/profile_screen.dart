import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:winek/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const String id='profile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseUser loggedInUser ;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0.0),
          child: SingleChildScrollView(
            
            child: Stack(
              children : <Widget>[
                Positioned(
                  top: 0.0,
                  right: 0,
                  left: 0,
                  bottom: 0.0,
                  child: Container(//this one c le cadre
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.blueGrey,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                Center(
                  child: Column(

                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        height: 48.0,
                      ),
                      Container(
                        child: ClipOval(
                          child: Image.network("https://images.unsplash.com/photo-1485873295351-019c5bf8bd2e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
                            fit: BoxFit.fill,
                          ),
                        ),
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(

                          border: Border.all(
                            color: Colors.blueGrey,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                      SizedBox(
                        height: 48.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0,right: 40.0),
                        child: Container(
                          height: 1.0,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                          ),

                        ),

                      ),
                      Wrap(
                        children: <Widget>[
                          Container (
                            padding: const EdgeInsets.only(left: 40.0,right:30.0),
                            child: Text(
                                'Utilisateur:',
                              style: TextStyle(
                                fontFamily: 'Monsterrat',
                                fontSize:20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),


                      Container(
                        width:130.0,
                        height: 23.0,
                        padding: EdgeInsets.only(top: 6.0),
                        child: TextField(

                          enabled: true,

                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.blue,

                          ),
                          decoration: InputDecoration(
                            hintText: 'testEvaluation',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                        ],
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0,right: 40.0),
                        child: Container(
                          //  child: Image.network(),
                          height: 1.0,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                          ),

                        ),

                      ),
                      Wrap(
                        children: <Widget>[
                          Container (
                            padding: const EdgeInsets.only(left: 40.0,right:30.0),
                            child: Text(
                              'Telephone:',
                              style: TextStyle(
                                fontFamily: 'Monsterrat',
                                fontSize:20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),


                          Container(
                            width:130.0,
                            height: 23.0,
                            padding: EdgeInsets.only(top: 6.0),
                            child: TextField(

                              enabled: true,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.black,

                              ),
                              decoration: InputDecoration(
                                hintText: '0123456789',
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 48.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0,right: 40.0),
                        child: Container(
                          //  child: Image.network(),
                          height: 1.0,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                          ),

                        ),

                      ),
                      Wrap(
                        children: <Widget>[
                          Container (
                            padding: const EdgeInsets.only(left: 30.0,right:20.0),
                            child: Text(
                              'Mot de passe :',
                              style: TextStyle(
                                fontFamily: 'Monsterrat',
                                fontSize:20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),


                          Container(
                            width:130.0,
                            height: 23.0,
                            padding: EdgeInsets.only(top: 6.0),
                            child: TextField(
                              obscureText: true,
                              enabled: true,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.black87,

                              ),
                              decoration: InputDecoration(
                                hintText: authService.loggedIn.displayName,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Material(
                        color: Colors.grey,
                        shadowColor: Colors.blueGrey,
                        child: IconButton(
                          splashColor: Colors.yellowAccent,
                          color: Colors.blueGrey,
                          icon: Icon(Icons.edit),
                          iconSize: 45.0,
                          tooltip: 'Edit',

                          onPressed: _edit() ,//_showDialog ,
                        ),
                      ),

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
  bool isEditable =false ;
  _edit() {
    setState(() {
      isEditable=true ;
      print(isEditable);
    });
  }
  String accountStatus = '******';
  FirebaseUser mCurrentUser;



  Future <FirebaseUser>_getCurrentUser () async {
    try{
      mCurrentUser = await authService.auth.currentUser();
      if (mCurrentUser!=null){
        authService.loggedIn= mCurrentUser ;
        print(loggedInUser.email);
        return mCurrentUser ;
      }}
    catch(e)
    {
      print (e) ;
    }
  }


  TextEditingController pseudoInputController ;
  TextEditingController telInputController;
  TextEditingController mdpInputController;
  @override
  initState() {
    pseudoInputController = new TextEditingController();
    telInputController = new TextEditingController();
    mdpInputController = new TextEditingController();

    super.initState();
    _getCurrentUser();
    print('here outside async');
  }
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


  void updateData() {// a verifier ????
    try {
      authService.db
          .collection('Utilisateur').document('Utilisateur/${authService.loggedIn}')
          .updateData({'description': 'Head First Flutter'});
    } catch (e) {
      print(e.toString());
    }
  }

  Future fireRef () async {
    final QuerySnapshot result = await Future.value(authService.db
        .collection('Utilisateur')
        .where('mail', isEqualTo: authService.loggedIn.email )
        .limit(1)
        .getDocuments());
    final List<DocumentSnapshot> documents = result.documents;
    if (documents == 1) {
      print("UserName Already Exits");
    } else {
      print("UserName is Available");
    }
  }
  String _imgNet() {
    authService.loggedIn.photoUrl== null || authService.loggedIn.photoUrl.isEmpty ?  authService.loggedIn.photoUrl  :"https://images.unsplash.com/photo-1485873295351-019c5bf8bd2e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"
    ;
  }
}
