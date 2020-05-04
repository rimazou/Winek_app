import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:winek/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;


import '../classes.dart';

class ProfileScreen extends StatefulWidget {
  static const String id='profile';
  final Utilisateur myuser;

  ProfileScreen(this.myuser);

  @override
  _ProfileScreenState createState() => _ProfileScreenState(myuser);
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseUser loggedInUser;

  String errMl, errPs, errTel;


  _ProfileScreenState(Utilisateur myuser);


  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        color: Colors.white,
        child: Center(
          child: SpinKitChasingDots(
            color: Color(0XFF389490),
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(28.0),
            child: AppBar(
              backgroundColor: Colors.white30,
              elevation: 0.0,
              iconTheme: IconThemeData(
                color: Colors.black54,
              ),

            ),),
          body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              child: Container(
                child: SingleChildScrollView(

                  child: Stack(
                    children: <Widget>[

                      Center(
                        child: Column(

                          children: <Widget>[
                            SizedBox(
                              height: 140,
                            ),
                            Container(
                              height: 500.0,
                              width: 320.0,
                            ),
                          ],),
                      ),

                      Center(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 180,
                            ),

                            Container( // carre principal
                              height: 380.0,
                              width: 320.0,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 70,),

                                  SizedBox(
                                    height: 26,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30.0, right: 30.0),
                                    child: Container(
                                      height: 1.0,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                      ),

                                    ),

                                  ),
                                  Container(

                                    padding: const EdgeInsets.only(
                                        left: 40.0, right: 30.0, top: 10.0),
                                    child: TextField(
                                      enabled: true,
                                      onChanged: (val) {
                                        pseudo = val;
                                      },
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'Montserrat',

                                        // decorationColor: Color(0XFFFFCC00),//Font color change
                                        //  backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
                                      ),
                                      decoration: InputDecoration(
                                        hintText: widget.myuser.pseudo,

                                        errorText: errPs,
                                        errorStyle: TextStyle(
                                            fontFamily: 'Montserrat',


                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                        contentPadding: EdgeInsets.only(left: 15,
                                            bottom: 0,
                                            top: 32,
                                            right: 15),
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,

                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 23,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30.0, right: 30.0),
                                    child: Container(
                                      height: 1.0,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                      ),

                                    ),

                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 40.0, right: 30.0),
                                    child: TextField(
                                      enabled: true,
                                      onChanged: (val) {
                                        tel = val;
                                      },
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'Montserrat',

                                        // decorationColor: Color(0XFFFFCC00),//Font color change
                                        //  backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
                                      ),
                                      decoration: InputDecoration(
                                        hintText: widget.myuser.tel == null
                                            ? 'aucun numero'
                                            : widget.myuser.tel,

                                        errorText: errTel,
                                        errorStyle: TextStyle(
                                            fontFamily: 'Montserrat',


                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                        contentPadding: EdgeInsets.only(left: 15,
                                            bottom: 0,
                                            top: 32,
                                            right: 15),
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,

                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 23,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30.0, right: 30.0),
                                    child: Container(
                                      height: 1.0,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                      ),

                                    ),

                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 40.0, right: 30.0),
                                    child: TextField(
                                      enabled: true,
                                      onChanged: (val) {
                                        mail = val;
                                      },
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'Montserrat',

                                        // decorationColor: Color(0XFFFFCC00),//Font color change
                                        //  backgroundColor: Color(0XFFFFCC00),//TextFormField title background color change
                                      ),
                                      decoration: InputDecoration(
                                        hintText: widget.myuser.mail,

                                        errorText: errMl,
                                        errorStyle: TextStyle(
                                            fontFamily: 'Montserrat',


                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                        contentPadding: EdgeInsets.only(left: 15,
                                            bottom: 0,
                                            top: 32,
                                            right: 15),
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,

                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: _edit(),
                                      ),
                                    ],
                                  ),

                                ],),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey[300],
                                  width: 3,),
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.grey[200],
                                    blurRadius: 20.0,),
                                ],
                                borderRadius: BorderRadius.circular(20),),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Column( //photos


                          children: <Widget>[
                            SizedBox(
                              height: 130,
                            ),
                            Center(
                              child: Container(
                                height: 100.0,
                                width: 100.0,

                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey[300],
                                    width: 3,),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Colors.grey[200],
                                      blurRadius: 20.0,),
                                  ],
                                ),
                                child: photoWig(),
                              ),
                            ),
                          ],
                        ),
                      ),


                      Positioned(
                        top: 53,
                        left: 200,
                        child: Padding(
                          padding: EdgeInsets.only(top: 60.0),
                          child: IconButton(

                            icon: Icon(
                              Icons.camera_alt,
                              size: 30.0,),
                            onPressed: () =>
                                showAlertDialog(
                                    context, "choisissez la source de l'image",
                                    "Source"),

                          ),
                        ),
                      ),
                      Positioned(
                        right: 120,
                        top: 12,
                        child: Row(
                          children: <Widget>[
                            Container(

                              height: 60.0,
                              width: 60.0,
                              child: Image.asset(
                                'images/logo.png', fit: BoxFit.fill,
                                height: 120.0,
                                width: 120.0,),
                            ),
                            Text(
                              'inek',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 25.0,
                                fontWeight: FontWeight.w900,
                                color: Color(0XFF3B466B),

                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        left: 96,
                        top: 50,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 20,),
                          child: Text(
                            'Compte',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                              color: Color(0XFF389490), //vert
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),


                    ],
                  ),
                ),
              )
          ),
        ),
      );
    }
  }

// tester si les chaines de caratceres ne sont pas vides
  Widget photoWig() {
    if (widget.myuser.photo != null) {
      return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17.0),

            child: Image.network(widget.myuser.photo,
              height: 110.0,

              gaplessPlayback: true,
              fit: BoxFit.fill,
            ),
          )
      );
    }
    else {
      return
        Center(
          child:
          ListView( //photos
            children: <Widget>[
              SizedBox(
                height: 16,),
              Icon(
                Icons.person,
                color: Color(0xFF5B5050),
                size: 105.0,
              ),
            ],),);
    }
  }

  bool isEditable = false;

  _edit() {
    modifier();
  }

  modifmail() {
    if (mail != null) {
      widget.myuser.mail = mail;
    }
  }

  modiftel() {
    if (tel != null) {
      widget.myuser.tel = tel;
    }
  }

  File _image;
  String _uploadedFileURL;

  Future updatePic(source) async {
    print('choooose file');
    File cropped;
    print('choooose file');
    _image = await ImagePicker.pickImage(source: source);

    if (_image != null) {
      cropped = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxHeight: 110,
        maxWidth: 110,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Rogner',
            toolbarColor: Color(0XFF389490), //vert
            statusBarColor: Colors.white,
            backgroundColor: Colors.white),


      );
    }
    if (cropped != null) {
      setState(() {
        _image = cropped;
      });
    }

    print('uploaaaaaaaaaadfile');
    setState(() {
      loading = true;
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('photos/${p.basename(_image.path)}}');
    _uploadedFileURL = widget.myuser.photo;
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
      authService.auth.currentUser().then((onValue) {
        authService.userRef.document(onValue.uid).updateData(
            {'photo': _uploadedFileURL});
        setState(() {
          print(widget.myuser.photo);
          widget.myuser.photo = _uploadedFileURL;
          print(widget.myuser.photo);
        });
      });
    });
    setState(() {
      loading = false;
    });
  }

  bool loading = false;
  modifier() {
    modifmail();
    modiftel();
    setState(() {
      loading = true;
    });
    print(' debutsignout');
    authService.auth.currentUser().then((onValue) {
      authService.userRef.document(onValue.uid).updateData(
          {
            'mail': widget.myuser.mail,
            'tel': widget.myuser.tel,
            'photo': widget.myuser.photo
          });
      onValue.updateEmail(widget.myuser.mail).then((onVal) {
        print('changed mail succeedeed');
      });
    });
    setState(() {
      loading = false;
    });
    print('succeddeed ?');
  }


  showAlertDialog(BuildContext context, String message, String heading) {
    // set up the buttons
    Widget GalleryButton = FlatButton(
      color: Color(0XFF389490),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Color(0XFF389490),
            //vert
          )
      ),
      child: Text('Gallerie', style: TextStyle(
        fontFamily: 'Montserrat',

        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),),
      onPressed: () {
        Navigator.pop(context);
        updatePic(ImageSource.gallery);
      },
    );
    Widget CameraButton = FlatButton(
      color: Color(0XFF3B466B),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Color(0XFF3B466B),
//vert
          )
      ),
      child: Text('Camera', style: TextStyle(
        fontFamily: 'Montserrat',

        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),),
      onPressed: () {
        Navigator.pop(context);
        updatePic(ImageSource.camera);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(heading),
      content: Text(message),
      backgroundColor: Colors.white,
      shape:
      RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
      actions: [

        GalleryButton,
        CameraButton,

      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  initState() {
    super.initState();

    print('here outside async');
  }

  String mail, pseudo, tel, photo;

  Future userID;


}