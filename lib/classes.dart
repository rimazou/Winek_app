import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Utilisateur {
  String pseudo;

  String tel;

  String mail;

  String photo;

  int batterie;

  bool connecte;

  List amis;

  List favoris;

  List groupes;

  List invitation_groupe;

  List invitation;

  List alertLIST;
  Map <String, dynamic> location;

  Utilisateur(
      {this.pseudo,
      this.tel,
      this.mail,
      this.photo,
      this.batterie,
      this.connecte,
      this.amis,
      this.favoris,
      this.groupes,
      this.alertLIST,
      this.invitation_groupe,
      this.invitation,
      this.location});

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
      'groupes': groupes,
      'invitationGroupe': invitation_groupe,
      'invitation ': invitation,
      'alertLIST': alertLIST,
      'location': location,
    };
  }

  Utilisateur.fromSnapshot(DataSnapshot data)
      : this(
          pseudo: data.value['pseudo'],
          tel: data.value['tel'],
          mail: data.value['mail'],
          photo: data.value['photo'],
          connecte: data.value['connecte'],
          batterie: data.value['batterie'],
          amis: data.value['amis'],
          favoris: data.value['favoris'],
          groupes: data.value['groupes'],
          invitation_groupe: data.value['invitationGroupe'],
          invitation: data.value['invitation'],
          alertLIST: data.value['alertLIST'],
          location: data.value['location'],
        );

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

class MsgPredefinis {
  Utilisateur utilisateur;
  Icon icon;
  String contenu;
  double pos_altitude;
  double pos_longitude;
}

abstract class Groupe {
  String nom;
  bool affiche;
  List membres;
  String admin;

  //----------fonctions--------------//

  Groupe({this.nom, this.affiche, this.membres, this.admin});
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

  LongTerme({String nom, bool affiche, List membres, String admin})
      : super(nom: nom, affiche: affiche, membres: membres, admin: admin);

  LongTerme.fromMap(Map<String, dynamic> data)
      : this(
          nom: data['nom'],
          admin: data['admin'],
          membres: new List<String>.from(data['membres']),
        );
}

class Voyage extends Groupe {
  double destination_altitude;
  double destination_longitude;
  String destination;

  //cette list contient les infos des membres a affiche sur la carte
  //a utiliser avec la barre d'info
  // et l'autre list qui est ds groupe, on l'utilise lors de la manipulation
  // du groupe : voir membres, ajouter, creer grp... ect
  //pour pouvoir gerer les deux types de grp au memes temps

  Voyage(
      {String nom,
      bool affiche,
      List membres,
      String admin,
      this.destination_altitude,
      this.destination_longitude,
      this.destination,
      })
      : super(nom: nom, affiche: affiche, membres: membres, admin: admin);

  Voyage.fromMap(Map<String, dynamic> data)
      : this(
          nom: data['nom'],
          admin: data['admin'],
          destination: data['destination'],
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
