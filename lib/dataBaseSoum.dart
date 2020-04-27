import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:observable/observable.dart';
import 'package:winek/main.dart';
import 'dart:core';
import 'classes.dart';
import 'package:winek/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class Database {
   String pseudo;
   String id ;
   String subiid ;
   String subipseudo ;
   List<dynamic> _modifiedUsersInterested;
   //static final  currentUser = AuthService().connectedID().toString() ;
   String currentUser = '2dE7ClNIkPMKWdZFiHcghx5dKzi1';
   String currentName;
   final CollectionReference userCollection = Firestore.instance.collection(
       'Utilisateur');

  Database({String pseudo , String subiid , String subipseudo , String  id ,  List<dynamic> modifiedUsersInterested}) {

    this.pseudo=pseudo;
    this.subipseudo=subipseudo;
    this.subiid=subiid;
    this.id=id ;
    _modifiedUsersInterested=modifiedUsersInterested;

    print('biiiiiiiiiiitch');
    print(_modifiedUsersInterested);
    print(this.pseudo);

    // this.currentUser = AuthService().connectedID().toString() ;

  }


   Future init(
       {String pseudo, String id, String subiid, String subipseudo }) async {
print('init');

currentName = await getPseudo(currentUser);
       print('sooooooooooo');
       print(currentName);

this.pseudo = pseudo != null ? pseudo : currentName;

     this.subipseudo = subipseudo != null ? subipseudo : currentName;
     print('eyyyy');
     print(this.subipseudo);// si la personne qui subit laction n'est pas currentUser
     this.subiid = this.subipseudo== currentName ? currentUser : await getID(this.subipseudo);

       print(this.subiid);

this.id = id != null ? id : await getID(pseudo);
   
         print('idddd');
print(this.id);

  await   userCollection
         .getDocuments()
         .then((QuerySnapshot data) {
       data.documents.forEach((doc) {
         if (doc.data['pseudo']==this.subipseudo)
           this._modifiedUsersInterested = doc.data['amis'];
       });
  });


var d = Database(pseudo: this.pseudo,
    subipseudo: this.subipseudo,
    id: this.id,
    subiid: this.subiid,
    modifiedUsersInterested: this._modifiedUsersInterested);
     return d ;
   }



  Future userUpdateData( { String name} ) async {
    // ajouter un amis a la liste de current
    Map map ;

    print('on comeeeeeenceeee');
    print(this.id);
    print(this.pseudo);
    print(this.subiid);

    map = ({'pseudo': this.pseudo, 'id': this.id});

    if (_modifiedUsersInterested.isNotEmpty) {
      _modifiedUsersInterested.add(map);
    }

    else {
    _modifiedUsersInterested= [];
    _modifiedUsersInterested.add(map);
    }
      /* map =({'pseudo': nom, 'id': idd});
    print(map);
    _modifiedUsersInterested =new List.of(map.values);
  }*/
    return await userCollection
        .document(subiid)
        .updateData(
        {'amis': _modifiedUsersInterested});}

  Future userDeleteData(String current) async {
    // supprimer une invit de pseudo de la liste de current
    return await userCollection.document(current).updateData({
      "invitation ": FieldValue.arrayRemove([pseudo])
    });
  }

  Future invitUpdateData(String current) async {
    // ajouter une invit de pseudo a la liste de current
    return await userCollection.document(current).updateData({
      "invitation ": FieldValue.arrayUnion([pseudo])
    });
  }

  Future friendDeleteData( String id) async {
    // supprimer un ami id de la liste de current, (id dans le constructeur)

if (_modifiedUsersInterested!=null){
    print(_modifiedUsersInterested);
    for (var map in _modifiedUsersInterested) {
      if (map["id"] == id) {
        _modifiedUsersInterested.remove(map);

      }}}

    if(_modifiedUsersInterested!=null)
      {
   return await userCollection
        .document(id)
        .updateData(
        {'amis': _modifiedUsersInterested}
    );}
else{
 return  await userCollection
       .document(id)
       .updateData(
       {'amis': []}
   );}
   /* return await userCollection.document(pseudo).updateData({
      "amis": FieldValue.arrayRemove([{pseudo: id , id: getID(id)}])
    });*/
  }

  List<String> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      String pseudo =doc.data['pseudo'] ?? '';
      return pseudo;
    }).toList();
  }

  Stream<List<String>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

   String get currentuser {
     return currentUser;
   }

   String get currentname {
     return currentName;
   }

  Stream<List<dynamic>> get friends {
    return userCollection.document(currentUser).snapshots().map((snap) {
      List<dynamic> friend =  snap.data['amis'];
      print(friend);
      return friend;
    });
  }

   /*List<dynamic> getfriends (String id){
      userCollection.document(id).get()
         .then((DocumentSnapshot doc) {
       List<dynamic> friend =  doc.data['amis'];
       print(friend);
       return friend;
     });
   }*/


   Stream<List<String>> get friendRequest {
    return userCollection.document(currentUser).snapshots().map((snap) {
      List<String> invit ;
      if (snap.data['invitation ']!=null)
        {invit = snap.data['invitation '].cast<String>();
        }print(invit);
      return invit;
    });
  }





   Future<List<Map<dynamic, dynamic>>> getlistfriend() async {
    // String id = await authService.connectedID();
     print(currentUser);
     List<dynamic> friendsid = List();
     await Firestore.instance
         .collection('Utilisateur')
         .document(currentUser)
         .get()
         .then((DocumentSnapshot doc) {
       friendsid = doc.data['amis'];
     });
     print(friendsid);
     List<dynamic> pseudos = List();
     for (String id in friendsid) {
       await Firestore.instance
           .collection('Utilisateur')
           .document(id)
           .get()
           .then((DocumentSnapshot doc) {
         pseudos.add(doc.data['pseudo']);
       });
     }
     print(pseudos);
     List<Map<dynamic, dynamic>> friendlist = List();
     for (int index = 0; index < friendsid.length; index++) {
       friendlist.add({'pseudo': pseudos[index], 'id': friendsid[index]});
     }
     return friendlist;
   }

   Future<List<Map<dynamic, dynamic>>> getUsers() async {
    // String currentUser = await authService.connectedID();
     print(currentUser);
     List<dynamic> userid = List();
     await Firestore.instance
         .collection('Utilisateur')
         .getDocuments()
         .then((QuerySnapshot data) {
       data.documents.forEach((doc) {
         userid.add(doc.documentID);});
     });
     print(userid);
     List<dynamic> pseudos = List();

       await Firestore.instance
           .collection('Utilisateur')
           .getDocuments()
           .then((QuerySnapshot data) {
         data.documents.forEach((doc) {
         pseudos.add(doc.data['pseudo']);});
       });

     print(pseudos);
     List<Map<dynamic, dynamic>> friendlist = List();
     for (int index = 0; index < userid.length; index++) {
       friendlist.add({'pseudo': pseudos[index], 'id': userid[index]});
     }
     return friendlist;
   }

   Future<String> getPseudo(String id) async {
     String pseudo;
    await Firestore.instance
         .collection('Utilisateur')
         .document(id).get()
        .then((DocumentSnapshot doc) {
      if(doc.data!=null) pseudo= doc.data['pseudo'] ;
       print(pseudo);

     });
     return pseudo.toString();}

   Future<String> getPhoto(String pseudo) async {
     String image;
     Firestore.instance
         .collection('Utilisateur')
         .where("pseudo", isEqualTo: pseudo)
         .limit(1)
         .snapshots()
         .listen((data) {
       data.documents.forEach((doc) {
         print('entreeeeeee');
         image = doc.data['photo'];
         print(image);
       }
       );
     });
     return image.toString();
   }
     
     
   Future<String> getID (String pseudo) async {
  String id;
  await userCollection
      .getDocuments()
      .then((QuerySnapshot data) {
    data.documents.forEach((doc) {
  if (doc.data['pseudo']==pseudo)
        id = doc.documentID;
    }
    );
  });
  print(id);return id.toString(); }

   Future<Null> changePseudo(String oldp, String newp) async {
     await userCollection
         .getDocuments()
         .then((QuerySnapshot data) {
       data.documents.forEach((doc) async {
         if (doc.data['pseudo'] == oldp) {
           await userCollection
               .document(doc.documentID)
               .updateData(
               {'pseudo': newp});
         }
         else {
           await Firestore
               .instance // Remplace this one with the one below *******************************
               .collection('Utilisateur')
               .document(currentUser).get()
               .then((DocumentSnapshot doc) async {
             List<dynamic> list = doc.data['amis'];
             if (list != null) {
               for (var map in list) {
                 if (map["pseudo"] == oldp) {
                   await Database(pseudo: oldp).friendDeleteData(
                       doc.documentID);
                   Database d = await Database().init(
                       pseudo: newp, subipseudo: doc.data['pseudo']);
                   await d.userUpdateData();
                 }
               }
             }
             List<dynamic> listinvit = doc.data['invitation '];
             if (listinvit != null) {
               for (var map in listinvit) {
                 if (map == oldp) {
                   print('why not working');
                   await Database(pseudo: oldp).userDeleteData(currentUser);
                   await Database(pseudo: newp)
                       .invitUpdateData(currentUser);
                 }
               }
             }
           });
           /* List<dynamic> list =doc.data['amis'];
          if(list!=null){
        for (var map in list){
          if (map["pseudo"] == oldp) {
            await Database(pseudo: oldp).friendDeleteData(doc.documentID);
            Database d= await Database().init(pseudo: newp , subipseudo: doc.data['pseudo'] );
            await d.userUpdateData();
          }}
          List<dynamic> listinvit =doc.data['invitation '];
          if(listinvit!=null){
            for (var map in listinvit){
              if (map == oldp) {
                await Database( pseudo: oldp).userDeleteData(doc.documentID);
                await Database(pseudo: newp)
                    .invitUpdateData(doc.documentID);}}*/
         }
       });
     });
   }

}

