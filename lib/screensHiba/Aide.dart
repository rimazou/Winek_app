import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winek/main.dart';

bool qst1;

class AidePage extends StatefulWidget {
  @override
  static const String id = 'Aide';
  _AidePageState createState() => _AidePageState();
}

class _AidePageState extends State<AidePage> {
  @override
  void initState() {
    qst1 = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primarycolor,
          title: Text(
            'Aide',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          width: 400,
          height: 600,
          child: Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Spacer(
                    flex: 1,
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          qst1 = !qst1;
                        });
                      },
                      child: Text(
                        'C’est quoi la différence entre un Voyage et un groupe à long terme ?',
                        style: TextStyle(
                          color: (qst1) ? secondarycolor : Color(0xff707070),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  (qst1)
                      ? Text(
                          'Un voyage est caractérisé par sa destination et permet à ses membres de se localiser mutuellement et d'
                          'échanger certaines informations comme leurs vitesses de déplacement, l'
                          'états de batterie de leurs téléphones portables et le temps restant jusqu'
                          'à leurs arrivées au point de rencontre. De plus, il offre un système de messagerie simple avec des messages prédéfinis, pour permettre aux membres de communiquer entre eux, sans en faire un tchat. Une fois tous les membres arrivent à destination le groupe sera fermé. En revanche un long terme offre seulement le service de localisation et se ferme que lorsque l'
                          'administrateur le décide.',
                          style: TextStyle(
                            color: Color(0xff707070),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                          ),
                        )
                      : Container(),
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          qst1 = !qst1;
                        });
                      },
                      child: Text(
                        'C’est quoi la différence entre un Voyage et un groupe à long terme ?',
                        style: TextStyle(
                          color: (qst1) ? secondarycolor : Color(0xff707070),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  (qst1)
                      ? Text(
                          'Un voyage est caractérisé par sa destination et permet à ses membres de se localiser mutuellement et d'
                          'échanger certaines informations comme leurs vitesses de déplacement, l'
                          'états de batterie de leurs téléphones portables et le temps restant jusqu'
                          'à leurs arrivées au point de rencontre. De plus, il offre un système de messagerie simple avec des messages prédéfinis, pour permettre aux membres de communiquer entre eux, sans en faire un tchat. Une fois tous les membres arrivent à destination le groupe sera fermé. En revanche un long terme offre seulement le service de localisation et se ferme que lorsque l'
                          'administrateur le décide.',
                          style: TextStyle(
                            color: Color(0xff707070),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                          ),
                        )
                      : Container(),
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          qst1 = !qst1;
                        });
                      },
                      child: Text(
                        'C’est quoi la différence entre un Voyage et un groupe à long terme ?',
                        style: TextStyle(
                          color: (qst1) ? secondarycolor : Color(0xff707070),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  (qst1)
                      ? Text(
                          'Un voyage est caractérisé par sa destination et permet à ses membres de se localiser mutuellement et d'
                          'échanger certaines informations comme leurs vitesses de déplacement, l'
                          'états de batterie de leurs téléphones portables et le temps restant jusqu'
                          'à leurs arrivées au point de rencontre. De plus, il offre un système de messagerie simple avec des messages prédéfinis, pour permettre aux membres de communiquer entre eux, sans en faire un tchat. Une fois tous les membres arrivent à destination le groupe sera fermé. En revanche un long terme offre seulement le service de localisation et se ferme que lorsque l'
                          'administrateur le décide.',
                          style: TextStyle(
                            color: Color(0xff707070),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                          ),
                        )
                      : Container(),
                  Spacer(
                    flex: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
