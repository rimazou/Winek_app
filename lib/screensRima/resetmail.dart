import 'package:winek/auth.dart';
import 'package:flutter/material.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';

class ResetMailScreen extends StatefulWidget {

  static const String id='resetM';

  @override
  _ResetMailScreenState createState() => _ResetMailScreenState();
}

class _ResetMailScreenState extends State<ResetMailScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(//tce widget permet de faire en sorte de scroller la page et pas la cacher avec le clavier
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),

                Container(

                  height: 60.0,
                  width: 60.0,
                  child: Image.asset('images/logo.png', fit: BoxFit.fill,height: 120.0,width: 120.0,),
                ),
                Text(
                  'Winek',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 26.0,
                    fontWeight: FontWeight.w900,
                    color:Color(0XFF3B466B),

                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'Mot de passe oublie',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF389490),//vert

                  ),
                ),
                SizedBox(
                  height: 80.0,
                ),
                TextField(
                  onChanged: (value) {
                     email = value;
                     !Validator.email(email) ? errMl=null :errMl='Veuillez entrer une adresse valide' ;

                  },
                  textAlign: TextAlign.center,

                  autocorrect: false,
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',

                    // decorationColor: Color(0XFFFFCC00),//Font color change
                    //  backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
                  ),
                  decoration: InputDecoration(
                    hintText: "Introduisez votre adresse mail ...",
                    hoverColor: Colors.black87,
                    errorText: errMl,
                    errorStyle: TextStyle(
                        fontFamily: 'Montserrat',

                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),



                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Material(
                    color: Color(0XFF389490),//vert
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed:(){
                       authService.sendPwdResetEmail(email);
                      } ,

                      minWidth: 140.0,
                      height: 37.0,
                      child: Text(
                        'Envoyer code de confirmation',

                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 15.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0,right: 0.0),
                  child: Container(
                    height: 1.0,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                    ),

                  ),

                ),
                SizedBox(
                  height: 20.0,
                ),
                /*Text(
                  'Introduisez le code de confirmation que vous venez de recevoir ...',
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',
                    fontSize:12.0,
                    // decorationColor: Color(0XFFFFCC00),//Font color change
                    //  backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
                  ),
                ),
                Container(
                  width: 200.0,
                  child: TextField(
                    // obscureText: true,
                    onChanged: (value) {
                      pwd = value;
                    },
                    textAlign: TextAlign.center,
                     maxLength: 6,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Montserrat',
                      fontSize:12.0,
                      // decorationColor: Color(0XFFFFCC00),//Font color change
                      //  backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
                    ),
                    decoration: InputDecoration(
                      //labelText: 'Email',
                      hintText: "Code de confimation",

                      hoverColor: Colors.black87,
                      errorText: errPw,
                      errorStyle: TextStyle(
                          fontFamily: 'Montserrat',

                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                    ),
                  ),
                ),*/
              ],
            ),

          ),
        ),
      ),
    );
  }
String pwd , errPw , email,errMl;

}
