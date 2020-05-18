import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:winek/auth.dart';
import 'package:winek/dataBaseSoum.dart';


class PlanifierArrets {
  String docId;

  PlanifierArrets({this.docId});


  addArretsToSubCol(String p, double l, double lo) async {
    final databaseReference = Firestore.instance;
    final String colPath = p + '/PlanifierArrets';

    final String docPath = p + '/PlanifierArrets' + '/Arrets';

    var id = await AuthService().connectedID();
    String pseudo = await Database().getPseudo(id);


    final snap = await databaseReference
        .document(p)
        .collection('PlanifierArrets')
        .document('Arrets')
        .get();

    if (!snap.exists) {
      await databaseReference
          .document(p)
          .collection('PlanifierArrets')
          .document("Arrets")
          .setData({
        "planArrets": [
          {'latitude': l, 'longitude': lo, 'pseudo': pseudo}
        ]
      });
    } else {
      await databaseReference
          .document(p)
          .collection('PlanifierArrets')
          .document("Arrets")
          .updateData({
        "planArrets": FieldValue.arrayUnion([
          {"latitude": l, "longitude": lo, "pseudo": pseudo}
        ]),
      });
    }
  }


}
