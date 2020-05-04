import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Utilisateur {
  String pseudo;

  String tel;

  String mail;

  String photo;

  int batterie;

  bool connecte;

  List<dynamic> amis;

  List<Map<String, dynamic>> favoris;

  List invitation;

  List alertLIST;

  Map <String, dynamic> location;

  Utilisateur({this.pseudo,
    this.tel,
    this.mail,
    this.photo,
    this.batterie,
    this.connecte,
    this.amis,
    this.favoris,
    this.alertLIST,
    this.invitation,
    this.location,
  });


  @override
  Map<String, dynamic> get map {
    return {
      'pseudo': pseudo,
      'tel': tel,
      'mail': mail,
      'photo': photo,
      'connecte': connecte,
      'batterie': batterie,
      'amis': amis,
      'favoris': favoris,
      'invitation ': invitation,
      'alertLIST': alertLIST,
      'location': location,
    };
  }

  Utilisateur.fromSnapshot (DataSnapshot data)
      :this(
    pseudo: data.value['pseudo'],
    tel: data.value['tel'],
    mail: data.value['mail'],
    photo: data.value['photo'],
    connecte: data.value ['connecte'],
    batterie: data.value['batterie'],
    amis: data.value['amis'],
    favoris: data.value['favoris'],
    invitation: data.value['invitation'],
    alertLIST: data.value ['alertLIST'],
    location: data.value['location'],
  );

  Utilisateur.fromdocSnapshot (DocumentSnapshot data)
      :this(
    pseudo: data.data['pseudo'],
    tel: data.data['tel'],
    mail: data.data['mail'],
    photo: data.data['photo'],
    connecte: data.data ['connecte'],
    batterie: data.data['batterie'],
    amis: data.data['amis'],
    //  favoris: List.from(data.data['favoris']),
    invitation: data.data['invitation'],
    alertLIST: data.data ['alertLIST'],
    location: data.data['location'],
  );


}

class MsgPredefinis {
  Utilisateur utilisateur;
  Icon icon;
  String contenu;
  double pos_altitude;
  double pos_longitude;
}

abstract class Groupe {
  String nom;
  List membres;
  String admin;

  //----------fonctions--------------//

  Groupe({this.nom, this.membres, this.admin});
/*
  void modifier_nom_groupe();
  void ajouter_membre();
  void supprimer_membre(); // que pour l'admin
  void fermer_groupe() ; // que pour l'admin
  void planifier_arret();
  void envoyer_msg();
   */
}

class LongTerme extends Groupe {
  // la liste des membres contient des utilisateurs

  LongTerme({String nom, List membres, String admin})
      : super(nom: nom, membres: membres, admin: admin);

  LongTerme.fromMap(Map<String, dynamic> data)
      : this(

          nom: data['nom'],
          admin: data['admin'],
          membres: new List.from(data['membres']),
        );

}

class Voyage extends Groupe {
  double destination_latitude;
  double destination_longitude;
  String destination;

  //cette list contient les infos des membres a affiche sur la carte
  //a utiliser avec la barre d'info
  // et l'autre list qui est ds groupe, on l'utilise lors de la manipulation
  // du groupe : voir membres, ajouter, creer grp... ect
  //pour pouvoir gerer les deux types de grp au memes temps

  Voyage({
    String nom,
    List membres,
    String admin,
    this.destination_latitude,
    this.destination_longitude,
    this.destination,
  }) : super(nom: nom, membres: membres, admin: admin);

  Voyage.fromMap(Map<String, dynamic> data)
      : this(
          nom: data['nom'],
          admin: data['admin'],
          destination: data['destination']['adresse'],
          destination_latitude: data['destination']['latitude'],
          destination_longitude: data['destination']['longitude'],
          membres: new List.from(data['membres']),
        );
}

class Membre {
  Utilisateur utilisateur;
  bool arrive;
  int temps_restant;
  MsgPredefinis msg_envoye;

  Membre({this.utilisateur, this.arrive, this.temps_restant, this.msg_envoye});
}
