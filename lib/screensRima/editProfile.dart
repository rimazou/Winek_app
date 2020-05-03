import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:winek/classes.dart';
import 'package:winek/screensRima/profile_screen.dart';

import '../auth.dart';

class EditProfile extends StatefulWidget {
  const EditProfile(this.myuser);

  @override
  _EditProfileState createState() => _EditProfileState(myuser);
  static const String id = 'profileedit';
  final Utilisateur myuser;
}

class _EditProfileState extends State<EditProfile> {
  _EditProfileState(myuser);

  @override
  void initState() {
    super.initState();
    _edit();
  }

  _edit() async {
    print(' fin editing');
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProfileScreen(widget.myuser)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Center(
            child: SpinKitChasingDots(
              color: Colors.deepPurpleAccent,
            ),
          ),
        ),
      ),
    );
  }
}
