import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:winek/auth.dart';
import 'package:winek/screens/profile_screen.dart';
import 'package:winek/screens/resetmail.dart';
class LoginScreen extends StatefulWidget {

  static const String id='login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String pwd, mail;


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

                Container(

                  height: 130.0,
                  child: Image.asset('images/logo.png'),
                ),
                Text(
                  'Winek',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  onChanged: (value) {
                    mail=value ;
                  },
                  style: TextStyle(
                    fontFamily: 'Montserrat',

                    color: Colors.black87,
                    //decorationColor: Color(0XFFFFCC00),//Font color change
                   // backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
                  ),
                  decoration: InputDecoration(
                    //hintText: 'Enter your email',
                    labelText: 'Email/pseudo',
                  //  counterText: 'email?',//le truc en bas a droite
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  onChanged: (value) {
                    pwd=value ;
                  },
                  obscureText: true,
                  autocorrect: false,

                  style: TextStyle(
                    fontFamily: 'Montserrat',

                    color: Colors.black87,
                   // decorationColor: Color(0XFFFFCC00),//Font color change
                  //  backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
                  ),
                  decoration: InputDecoration(
                   // hintText: 'Enter your password.',
                    labelText: 'Mot de passe',
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
                FlatButton(
                  child: Text(
                    'mot de passe oublie ?',
                    style: TextStyle(
                      color: Colors.black87 ,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, ResetMailScreen.id);
                  },
                ),
                SizedBox(
                  height: 24.0,
                ),

                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () => _testSignInWithGoogle() ,//_signInG(),
                          minWidth: 140.0,
                          height: 42.0,

                          child: Text(

                            'SignInG',
                            style: TextStyle(
                              fontFamily: 'Montserrat',


                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color: Color(394669),
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () async{
                           try{ final user = await authService.auth.signInWithEmailAndPassword(
                                email: mail,
                                password: pwd);
                            if (user!=null)
                              {
                                Navigator.pushNamed(context, ProfileScreen.id);

                              }}
                              catch(e)
                            {
                              print(e);
                            }
                          },

                          minWidth: 140.0,
                          height: 42.0,
                          child: Text(
                            'Log In',
                            
                            style: TextStyle(
                              color: Colors.white ,
                            fontFamily: 'Montserrat',

                          ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }
/*  Future<FirebaseUser> _signInG() async {
    GoogleSignInAccount googleUser = await authService.googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = (await authService.auth.signInWithCredential(credential)) as FirebaseUser;
    print("signed in " + user.displayName);
    return user;
  }*/
  Future<String> _testSignInWithGoogle() async {
    final GoogleSignInAccount googleUser = await authService.googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = (await authService.auth.signInWithCredential(credential)).user;

    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await authService.auth.currentUser();
    assert(user.uid == currentUser.uid);

    print(  currentUser.email);
    if (user!=null)
    {
      Navigator.pushNamed(context, ProfileScreen.id);

    }
  }

}
