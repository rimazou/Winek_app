import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winek/main.dart';

bool qst1;
bool qst2;
bool qst3;
bool qst4;
bool qst5;
bool qst6;
bool qst7;
bool qst8;
bool qst9;
bool qst10;
bool qst11;
bool qst12;
bool qst13;
bool qst14;
bool qst15;

class AidePage extends StatefulWidget {
  @override
  static const String id = 'Aide';
  _AidePageState createState() => _AidePageState();
}

class _AidePageState extends State<AidePage> {
  @override
  void initState() {
    qst1 = false;
    qst2 = false;
    qst3 = false;
    qst4 = false;
    qst5 = false;
    qst6 = false;
    qst7 = false;
    qst8 = false;
    qst9 = false;
    qst10 = false;
    qst11 = false;
    qst12 = false;
    qst13 = false;
    qst14 = false;
    qst15 = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primarycolor,
        title: Text(
          'Aide',
          style: TextStyle(
            color: Colors.white,
            fontSize: responsivetext(20),
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            // amis
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),
              child: Text(
                'Amis',
                style: TextStyle(
                  color: primarycolor,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Montserrat',
                  fontSize: responsivetext(15),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    qst1 = !qst1;
                  });
                },
                child: Text(
                  ' je n’ai pas d’amis, comment je fais ?',
                  style: TextStyle(
                    color: (qst1) ? secondarycolor : Color(0xff707070),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    fontSize: responsivetext(15),
                  ),
                ),
              ),
            ),
            (qst1)
                ? Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),
                    child: Text(
                      'Allez vers la liste d’amis, faites une recherche et ajoutez la personne que vous voulez, puis patientez jusqu’à ce qu’elle accepte l’invitation.',
                      style: TextStyle(
                        color: Color(0xff5B5050),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        fontSize: responsivetext(15),
                      ),
                    ),
                  )
                : Container(),
            // qst2:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    qst2 = !qst2;
                  });
                },
                child: Text(
                  'Comment accepter ou refuser une invitation ?',
                  style: TextStyle(
                    color: (qst2) ? secondarycolor : Color(0xff707070),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    fontSize: responsivetext(15),
                  ),
                ),
              ),
            ),
            (qst2)
                ? Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),
                    child: Text(
                      'Allez vers la liste d’amis puis appuyez sur l’icône en haut à droite qui va vous renvoyer vers la liste des invitations.',
                      style: TextStyle(
                        color: Color(0xff5B5050),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        fontSize: responsivetext(15),
                      ),
                    ),
                  )
                : Container(),
            // qst3:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    qst3 = !qst3;
                  });
                },
                child: Text(
                  'Comment consulter le profil de quelqu’un ?',
                  style: TextStyle(
                    color: (qst3) ? secondarycolor : Color(0xff707070),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    fontSize: responsivetext(15),
                  ),
                ),
              ),
            ),
            (qst3)
                ? Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),

              child: Text(
                      'En appuyant sur l’utilisateur soit dans la liste d’amis, d’utilisateurs ou d’invitations.',
                      style: TextStyle(
                        color: Color(0xff5B5050),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        fontSize: responsivetext(15),
                      ),
                    ),
                  )
                : Container(),
            //groupe
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),

              child: Text(
                'Groupes',
                style: TextStyle(
                  color: primarycolor,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Montserrat',
                  fontSize: responsivetext(15),
                ),
              ),
            ),
            // qst4:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),

              child: GestureDetector(
                onTap: () {
                  setState(() {
                    qst4 = !qst4;
                  });
                },
                child: Text(
                  'Quelle est la différence entre un Voyage et un groupe à long terme ?',
                  style: TextStyle(
                    color: (qst4) ? secondarycolor : Color(0xff707070),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    fontSize: responsivetext(15),
                  ),
                ),
              ),
            ),
            (qst4)
                ? Padding(padding: EdgeInsets.symmetric(
                horizontal: responsiveheight(5), vertical: responsivewidth(5)),

                    child: Text(
                      'Un voyage est caractérisé par sa destination et permet à ses membres de se localiser mutuellement et d’échanger certaines informations comme leurs vitesses de déplacement, l’état de batterie de leurs appareils et le temps restant pour arriver à destination. De plus, ils peuvent s’envoyer des alertes ou planifier des arrêts. Une fois que tous les membres arrivent à destination le groupe sera fermé. En revanche un long terme offre seulement le service de localisation et sera fermé que lorsque l’administrateur le décide.',
                      style: TextStyle(
                        color: Color(0xff5B5050),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        fontSize: responsivetext(15),
                      ),
                    ),
                  )
                : Container(),
            // qst5:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),

              child: GestureDetector(
                onTap: () {
                  setState(() {
                    qst5 = !qst5;
                  });
                },
                child: Text(
                  'Pourquoi mon nouveau groupe ne contient pas les amis que j’ai ajoutés',
                  style: TextStyle(
                    color: (qst5) ? secondarycolor : Color(0xff707070),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    fontSize: responsivetext(15),
                  ),
                ),
              ),
            ),
            (qst5)
                ? Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),

              child: Text(
                      'Il faut attendre que les membres ajoutés acceptent l’invitation du groupe.',
                      style: TextStyle(
                        color: Color(0xff5B5050),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        fontSize: responsivetext(15),
                      ),
                    ),
                  )
                : Container(),
            // qst6:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),

              child: GestureDetector(
                onTap: () {
                  setState(() {
                    qst6 = !qst6;
                  });
                },
                child: Text(
                  'Pourquoi mon voyage n’existe plus?',
                  style: TextStyle(
                    color: (qst6) ? secondarycolor : Color(0xff707070),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    fontSize: responsivetext(15),
                  ),
                ),
              ),
            ),
            (qst6)
                ? Padding(padding: EdgeInsets.symmetric(
                horizontal: responsiveheight(5), vertical: responsivewidth(5)),

                    child: Text(
                      'Une fois que votre voyage soit terminé, et que tous les membres arrivent à destination, le groupe se ferme automatiquement.',
                      style: TextStyle(
                        color: Color(0xff5B5050),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        fontSize: responsivetext(15),
                      ),
                    ),
                  )
                : Container(),
            // qst7:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),

              child: GestureDetector(
                onTap: () {
                  setState(() {
                    qst7 = !qst7;
                  });
                },
                child: Text(
                  'Où est ce que je trouve les informations d’un membre dans mon groupe voyage ?',
                  style: TextStyle(
                    color: (qst7) ? secondarycolor : Color(0xff707070),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    fontSize: responsivetext(15),
                  ),
                ),
              ),
            ),
            (qst7)
                ? Padding(padding: EdgeInsets.symmetric(
                horizontal: responsiveheight(5), vertical: responsivewidth(5)),

                    child: Text(
                      'En cliquant sur sa bulle dans la liste des membres du voyage,en bas de la carte.',
                      style: TextStyle(
                        color: Color(0xff5B5050),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        fontSize: responsivetext(15),
                      ),
                    ),
                  )
                : Container(),
            //favoris
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),

              child: Text(
                'Favoris',
                style: TextStyle(
                  color: primarycolor,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Montserrat',
                  fontSize: responsivetext(15),
                ),
              ),
            ),
            // qst8:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),

              child: GestureDetector(
                onTap: () {
                  setState(() {
                    qst8 = !qst8;
                  });
                },
                child: Text(
                  'À quoi sert cette liste d’endroits favoris ?',
                  style: TextStyle(
                    color: (qst8) ? secondarycolor : Color(0xff707070),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    fontSize: responsivetext(15),
                  ),
                ),
              ),
            ),
            (qst8)
                ? Padding(padding: EdgeInsets.symmetric(
                horizontal: responsiveheight(5), vertical: responsivewidth(5)),

                    child: Text(
                      'Vous pouvez y accéder lors de la création de vos voyages, ainsi vous n’aurez pas à rechercher cet endroit de nouveau quand vous introduirez votre destination.',
                      style: TextStyle(
                        color: Color(0xff5B5050),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        fontSize: responsivetext(15),
                      ),
                    ),
                  )
                : Container(),
            // qst9:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),

              child: GestureDetector(
                onTap: () {
                  setState(() {
                    qst9 = !qst9;
                  });
                },
                child: Text(
                  'Comment ajouter un  endroit favoris ?',
                  style: TextStyle(
                    color: (qst9) ? secondarycolor : Color(0xff707070),
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                    fontSize: responsivetext(15),
                  ),
                ),
              ),
            ),
            (qst9)
                ? Padding(padding: EdgeInsets.symmetric(
                horizontal: responsiveheight(5), vertical: responsivewidth(5)),

                    child: Text(
                      'Pour ajouter un endroit favoris: allez au “favoris”, vous y trouverez la liste de vos endroits favoris, en bas de l’écran sur cette même page, cliquez sur le bouton “+” et faites votre recherche.',
                      style: TextStyle(
                        color: Color(0xff5B5050),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        fontSize: responsivetext(15),
                      ),
                    ),
                  )
                : Container(),
            //aletes
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),

              child: Text(
                'Alertes',
                style: TextStyle(
                  color: primarycolor,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Montserrat',
                  fontSize: responsivetext(15),
                ),
              ),
            ),
            // qst10:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),

              child: GestureDetector(
                onTap: () {
                  setState(() {
                    qst10 = !qst10;
                  });
                },
                child: Text(
                  'Comment faire si je juge nécessaire d’informer les autres membres de mon groupe sur une chose qui m’est arrivée en chemin? ',
                  style: TextStyle(
                    color: (qst10) ? secondarycolor : Color(0xff707070),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    fontSize: responsivetext(15),
                  ),
                ),
              ),
            ),
            (qst10)
                ? Padding(padding: EdgeInsets.symmetric(
                horizontal: responsiveheight(5), vertical: responsivewidth(5)),

                    child: Text(
                      'Faites apparaître votre liste d’alertes grâce au bouton gris en bas de votre écran et cliquez sur l’alerte de votre choix.',
                      style: TextStyle(
                        color: Color(0xff5B5050),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        fontSize: responsivetext(15),
                      ),
                    ),
                  )
                : Container(),
            // qst11:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),

              child: GestureDetector(
                onTap: () {
                  setState(() {
                    qst11 = !qst11;
                  });
                },
                child: Text(
                  'L’information que je veux partager avec mon groupe ne figure pas dans la liste citée ci-dessus, que faire ? ',
                  style: TextStyle(
                    color: (qst11) ? secondarycolor : Color(0xff707070),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    fontSize: responsivetext(15),
                  ),
                ),
              ),
            ),
            (qst11)
                ? Padding(padding: EdgeInsets.symmetric(
                horizontal: responsiveheight(5), vertical: responsivewidth(5)),

                    child: Text(
                      'Et bien vous n’avez qu’à la personnaliser ! Avec le bouton "personnaliser" qui se trouve en haut de la liste d’alertes ; en introduisant le contenu que vous voulez, elle sera rajoutée à votre liste et vous pourrez l’utiliser quand vous le voudrez. ',
                      style: TextStyle(
                        color: Color(0xff5B5050),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        fontSize: responsivetext(15),
                      ),
                    ),
                  )
                : Container(),
            // qst12:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),

              child: GestureDetector(
                onTap: () {
                  setState(() {
                    qst12 = !qst12;
                  });
                },
                child: Text(
                  'Maintenant je me demande si je peux supprimer une de mes alertes personnalisées ?',
                  style: TextStyle(
                    color: (qst12) ? secondarycolor : Color(0xff707070),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    fontSize: responsivetext(15),
                  ),
                ),
              ),
            ),
            (qst12)
                ? Padding(padding: EdgeInsets.symmetric(
                horizontal: responsiveheight(5), vertical: responsivewidth(5)),

                    child: Text(
                      'C’est possible, glissez l’alerte à gauche où à droite et vous ne la trouverez plus dans la fameuse liste.',
                      style: TextStyle(
                        color: Color(0xff5B5050),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        fontSize: responsivetext(15),
                      ),
                    ),
                  )
                : Container(),
            // qst13:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),

              child: GestureDetector(
                onTap: () {
                  setState(() {
                    qst13 = !qst13;
                  });
                },
                child: Text(
                  ' Dit comme ça, envoyer des alertes a l’air facile comme passer une lettre à la poste, mais comment je fais pour savoir si j’ai reçu une alerte ? ',
                  style: TextStyle(
                    color: (qst13) ? secondarycolor : Color(0xff707070),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    fontSize: responsivetext(15),
                  ),
                ),
              ),
            ),
            (qst13)
                ? Padding(padding: EdgeInsets.symmetric(
                horizontal: responsiveheight(5), vertical: responsivewidth(5)),

                    child: Text(
                      'Instinctivement vous consultez votre boite aux lettres, non ? Oui on ne rigole pas, vous en disposez d’une sur Winek, c’est le bouton rond avec l’icône de message à droite de votre écran.',
                      style: TextStyle(
                        color: Color(0xff5B5050),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        fontSize: responsivetext(15),
                      ),
                    ),
                  )
                : Container(),

            // qst14:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveheight(5),
                  vertical: responsivewidth(5)),

              child: GestureDetector(
                onTap: () {
                  setState(() {
                    qst14 = !qst14;
                  });
                },
                child: Text(
                  'Très bien, je vois que j’ai reçu des alertes et je sais même qui me les a envoyés et quand je les ai reçues, on a fait le tour des fonctionnalités autour des alertes, non ? ',
                  style: TextStyle(
                    color: (qst14) ? secondarycolor : Color(0xff707070),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    fontSize: responsivetext(15),
                  ),
                ),
              ),
            ),
            (qst14)
                ? Padding(padding: EdgeInsets.symmetric(
                horizontal: responsiveheight(5), vertical: responsivewidth(5)),

                    child: Text(
                      'Et si on vous disait que, pas encore ! Il reste un dernier truc ; si vous cliquez sur une de vos alertes reçues, vous pourrez la visualiser sur la map là où elle a été envoyée, pratique ne pensez-vous pas ?',
                      style: TextStyle(
                        color: Color(0xff5B5050),
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                        fontSize: responsivetext(15),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
