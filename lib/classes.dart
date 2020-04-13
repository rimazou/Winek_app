
class Utilisateur {

  String pseudo ;
  String tel ;
  String mail ;
  String photo;
  String mdp ;
  double vitesse ;
  double posLatitude ;
  double posLongitude ;
  int batterie ;
  bool connecte ;
  List amis ;
  List favoris ;
  List groupes ;
  List invitationGroupe ;
  List invitation ;


  Utilisateur({this.pseudo, this.tel, this.mail, this.photo, this.mdp,
      this.vitesse, this.posLatitude, this.posLongitude, this.batterie,
      this.connecte, this.amis, this.favoris, this.groupes,
      this.invitationGroupe,
      this.invitation});
  //---------- les fonctions--------------//
/*


 void ajouter_amis() ; //envoyer une invitation a un amis
 void supprimer_amis() ; // l'enlever de sa liste d'amis
 void accepter_invitation() ;//devenir amis des deux cotes ,
                             //les deux vont s'ajouter ds la liste d'amis de l'autre
 void refuser_invitation() ; //l'enlever de la liste des invitations
 void ajouter_favoris() ; //ajouter des lieux favoris
 void supprimer_favoris() ; // supprimer des lieux de la liste

 void creer_groupe() ;
 void quitter_groupe() ;
 void afficher_groupe() ;


 */
  void connecter(){}
  void deconnecter(){}



  @override
  Map<String,dynamic> get map {
    return {
      'pseudo': pseudo,
      'tel': tel,
      'mail': mail,
      'photo': photo,
    'mdp': mdp ,

    'connecte': connecte,
      'vitesse' : vitesse ,
    'posLatitude':posLatitude ,
    'posLongitude': posLongitude ,
     'batterie': batterie ,
     'amis' : amis ,
    'favoris': favoris ,
   'groupes': groupes ,
    'invitationGroupe': invitationGroupe ,
   'invitation ':  invitation ,



  };
  }

  void changerMdp(String value) {
    mdp = value;
  }

  void changerPhoto(String value) {
    photo = value;
  }


  void changerTel(String value) {
    tel = value;
  }

 void changerPseudo(String value) {
    pseudo = value;
  }




}
/*
class MsgPredefinis {
  Utilisateur utilisateur;
  Icon icon ;
  String contenu ;
  double pos_altitude ;
  double pos_longitude ;

}

abstract class Groupe {
  String nom ;
  bool affiche ;
  List membres;
  Utilisateur admin ;

  //----------fonctions--------------//

  Groupe({this.nom , this.affiche , this.membres , this.admin});

  void modifier_nom_groupe();
  void ajouter_membre();
  void supprimer_membre(); // que pour l'admin
  void fermer_groupe() ; // que pour l'admin
  void planifier_arret();
  void envoyer_msg();

}

class LongTerme extends Groupe{
  // la liste des membres contient des utilisateurs

  LongTerme({String nom , bool affiche , List membres , Utilisateur admin })
      : super(nom :nom ,
      affiche : affiche ,
      membres : membres ,
      admin : admin);
}

class Voyage extends Groupe{
  double destination_altitude ;
  double destination_longitude ;
  // la liste des membres contient des membres (class membre)

  Voyage({String nom , bool affiche , List membres , Utilisateur admin ,
    this.destination_altitude , this.destination_longitude})
      :super(nom :nom ,
      affiche : affiche ,
      membres : membres ,
      admin : admin);

}

class Membre {
  Utilisateur utilisateur;
  bool arrive ;
  int temps_restant ;
  MsgPredefinis msg_envoye ;

  Membre({this.utilisateur, this.arrive , this.temps_restant , this.msg_envoye});

}

//register
import 'package:authetification/auth.dart';
import 'package:authetification/classes.dart';
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
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 0.0,
                  child: Container(
                    //rajouter la pdp du user si existe sinon icone appareil photo

                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      border: Border.all(
                        color: Colors.blueGrey,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
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
                      //rajouter la pdp du user si existe sinon icone appareil photo
                      height: 100.0,
                      width: 100.0,

                      decoration: BoxDecoration(

                        border: Border.all(
                          color: Colors.blueGrey,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                    Row(
                      children: <Widget>[
                        Text(
                          'Utilisateur',
                          style: TextStyle(

                            fontFamily: 'Montserrat',
                            color: Colors.blue,
                          ),
                        ),
                        TextField(
                          enabled: true,

                          style: TextStyle(
                          fontFamily: 'Montserrat',
                            color: Colors.blue,

                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
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
                    Row(
                      children: <Widget>[
                        Text(
                          'Telephone',
                          style: TextStyle(

                            fontFamily: 'Montserrat',
                            color: Colors.blue,
                          ),
                        ),
                        TextField(
                          enabled: true ,

                          style: TextStyle(
                            fontFamily: 'Montserrat',

                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
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
                    Row(
                      children: <Widget>[
                        Text(
                          'Mot de passe',
                          style: TextStyle(

                            fontFamily: 'Montserrat',
                            color: Colors.blue,
                          ),
                        ),
                        TextField(
                          enabled: true ,

                          style: TextStyle(
                            fontFamily: 'Montserrat',

                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
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
  FirebaseAuth _auth;



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


void updateData() {
  try {
    authService.db
        .collection('Utilisateur').document('Utilisateur/${authService.loggedIn}')
        .updateData({'description': 'Head First Flutter'});
  } catch (e) {
    print(e.toString());
  }
}
  }

 */