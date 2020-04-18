import 'package:flutter/material.dart';
import 'package:password_strength/password_strength.dart';

class ResetScreen extends StatefulWidget {

  static const String id='reset';

  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {

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
                  height: 100.0,
                ),
                Text(
                  'Nouveau mot de passe',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 100.0,
                ),
                TextField(
                  // obscureText: true,
                  onChanged: (value) {
                    pwd = value;
                    double strength = estimatePasswordStrength(pw);

                    if (strength < 0.3)
                      errPw='Password too weak' ;
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
                    labelText: 'Mot de passe',

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
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  // obscureText: true,
                    autocorrect: false,
                    textAlign: TextAlign.center,

                    onChanged: (value) {
                      pw = value;
                      match();
                    },
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Montserrat',

                      // decorationColor: Color(0XFFFFCC00),//Font color change
                      //  backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
                    ),
                    decoration:
                    InputDecoration(
                      labelText: 'Confirmer le mot de passe',
                      errorText: errPwd,
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
                    )


                ),
                SizedBox(
                  height: 140.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: _resetPWD() ,

                      minWidth: 140.0,
                      height: 42.0,
                      child: Text(
                        'Confirmer',

                        style: TextStyle(
                          fontFamily: 'Montserrat',

                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }

  String errPwd ,errPw, pw, pwd;
  void match() {
    setState(() {
      if (pw != pwd) {
        errPwd='Veuillez introduire le meme mot de passe ';
      } else {
        errPwd=null;
      }
    });
  }

  _resetPWD() {

  }
}
