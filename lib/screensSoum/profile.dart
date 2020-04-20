import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../dataBaseSoum.dart';
import 'usersListScreen.dart';


class ProfileScreen2 extends StatefulWidget {
  static const String id='profile';
  final String pseudo ;
  final String currentUser ;


  const ProfileScreen2( this.pseudo,this.currentUser);

  @override
  _ProfileScreen2State createState() => _ProfileScreen2State(pseudo,currentUser);
}

class _ProfileScreen2State extends State<ProfileScreen2> {
  String id ;
  String currentUser ;
  String online='online' ;
  String who='marche pas' ;
  String mail ='marche pas';
  String phone='marche pas' ;
  String image ;
  double size ;
  final CollectionReference userCollection = Firestore.instance.collection('Utilisateur');
  _ProfileScreen2State(String id,String currentUser){
    this.id=id;
    this.currentUser=currentUser;
    size=102;
    userCollection.document(id)
        .snapshots()
        .listen((data) {
        setState(() {
          mail=data.data['mail'];
          phone=data.data['tel']; });});

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
      );});*/}


  @override
  void initState() {
    super.initState();
      userCollection.document(currentUser) // id du doc
        .get()
        .then((DocumentSnapshot doc) {
      if ( doc["amis"].contains(id))// amis*
          {setState(() {who='Supprimer';size=138;});
      }
      else{
            userCollection.document(id)
            .snapshots()
            .listen((doc) {
              if (doc["invitation"].contains(currentUser)) // amis*
                  {setState(() {
                  who = 'Annuler l\'invitaion';size = 102;});}

              else if (!doc["amis"].contains(currentUser) &&
                  !doc["invitation"].contains(currentUser)) {
                setState(() {who = 'Ajouter';size = 138;});}
            });}
    });


    userCollection.document(id)
        .snapshots()
        .listen((data) {
        if ( data["amis"].contains(id))
        {setState(() {
          who='Supprimer'; size=138;});}

        else{
          userCollection.document(id)
              .snapshots()
              .listen((data) {
            setState(() {
              if (data["invitation"].contains(currentUser)) // amis*
                  {setState(() {
                  who = 'Annuler l\'invitaion';size = 102;});}

              else if (!data["amis"].contains(currentUser) &&
                  !data["invitation"].contains(currentUser)) {
                setState(() {
                  who = 'Ajouter';size = 138;});}
            });
          });}//fin else
    });}



  Widget photo() {
    userCollection.document(id)
        .snapshots()
        .listen((data) {
      image = data['photo'];
    });
    if (image!=null) {
      return Center(
        child: Image(image: NetworkImage(image)),
      );
    }
    else {return
      Center(
        child :
        ListView(  //photos
          children: <Widget>[
            SizedBox(
              height: 16,),
            Icon(
              Icons.person,
              color: Color(0xFF5B5050),
              size: 105.0,),
          ],), );
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
          child : AppBar(
            backgroundColor: Colors.white30,
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Colors.black54,),

          ),),
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
                        height:  500.0,
                        width: 320.0,
                      ),],),
                ),

                Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 140,
                      ),

                      Container(// carre principal
                        height:  400.0,
                        width: 320.0,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 70,),
                            Container(
                              padding: const EdgeInsets.only(left: 40.0,right:30.0),
                              child :Text(
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
                              padding: const EdgeInsets.only(left: 40.0,right:30.0),
                              child :Text(
                                Database().getPseudo(id),
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
                              padding: const EdgeInsets.only(left: 40.0,right:30.0),
                              child :Text(
                                phone,
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
                              padding: const EdgeInsets.only(left: 40.0,right:30.0),
                              child :Text(
                                mail,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff000000),
                                ),),),],),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey[300],
                            width: 3,),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.grey[200],
                              blurRadius: 20.0,),],
                          borderRadius: BorderRadius.circular(20),),
                      ),
                    ],
                  ),),


                Positioned(
                  top:510,
                  right: size,
                  left: size,
                  bottom: 80,

                  child:
                  Container(
                    height:  200.0,
                    width: 30.0,
                    //Bouton ajouter
                    child:MaterialButton(
                      child:Center(child: Text(
                        who,
                        style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,),),),
                      onPressed:
                          () async {

                        if (who=="Ajouter" ) {//envoyer invit
                          setState(() {who="Annuler l\'invitaion"; size=102;});
                          await Database(id : Database.currentUser).invitUpdateData(id);

                        }
                        else
                        {
                          if (who=='Annuler l\'invitaion' )
                          {
                            setState(() {who="Ajouter";size=138; });
                            await Database(id : Database.currentUser).userDeleteData(id);

                          }
                          else{ // if who=supprimer
                            setState(() {who="Ajouter"; size=138;});
                            await Database(id : id).friendDeleteData(Database.currentUser);
                            await Database(id : Database.currentUser).friendDeleteData(id);}
                        }},),

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
                  child : Column(  //photos


                    children: <Widget>[
                      SizedBox(
                        height: 90,
                      ),
                      Container(
                          height:  110.0,
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
                                blurRadius: 20.0,),],),
                          child:photo()),],),),
              ],


            ),),
        ),
      ),
    );

  }


}