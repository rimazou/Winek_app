import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:winek/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:winek/main.dart';
import 'package:winek/screensRima/login_screen.dart';
import '../classes.dart';

var _controller;
var _controller1;
var _controller2;
String nv_pseudo;
String nv_tel;
String nv_mail;
bool _loading;
final GlobalKey<ScaffoldState> _profilekey = new GlobalKey<ScaffoldState>();

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile';
  final Utilisateur myuser;

  ProfileScreen(this.myuser);

  @override
  _ProfileScreenState createState() => _ProfileScreenState(myuser);
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseUser loggedInUser;

  String errMl, errPs, errTel;
  @override
  void initState() {
    _controller = TextEditingController();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    nv_pseudo = '';
    nv_tel = '';
    nv_mail = '';
    _loading = false;
  }

  _ProfileScreenState(Utilisateur myuser);

  _showSnackBar(String value) {
    final snackBar = new SnackBar(
      content: new Text(
        value,
        style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600),
      ),
      duration: new Duration(seconds: 2),
      //backgroundColor: Colors.green,
      action: new SnackBarAction(label: 'Ok', onPressed: () {
        print('press Ok on SnackBar');
      }),
    );
    _profilekey.currentState.showSnackBar(snackBar);
  }
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
      return ModalProgressHUD(
        inAsyncCall: _loading,
        child: SafeArea(
          child: Scaffold(
            key: _profilekey,
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            /*appBar: PreferredSize(
              preferredSize: Size.fromHeight(28.0),
              child: AppBar(
                backgroundColor: Colors.white30,
                elevation: 0.0,
                iconTheme: IconThemeData(
                  color: Colors.black54,
                ),
              ),),*/
            body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                child: Container(
                  child: SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        /*  Center(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 140,
                              ),
                              Container(
                                height: 500.0,
                                width: 320.0,
                              ),
                            ],
                          ),
                        ),*/
                        Center(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 180,
                              ),
                              Container(
                                // carre principal
                                height: 380.0,
                                width: 320.0,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 70,
                                    ),
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
                                          left: 30.0, right: 30.0, top: 15.0),
                                      child: FlatButton(
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                              //   namedialog(groupe.nom),
                                              AlertDialog(
                                                shape:
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        20)),
                                                contentPadding:
                                                EdgeInsets.all(15),
                                                title: Text(
                                                  'changer le pseudo ',
                                                  style: TextStyle(
                                                    fontFamily:
                                                    'Montserrat',
                                                    fontSize: 19,
                                                    fontWeight:
                                                    FontWeight.w700,
                                                    color: primarycolor,
                                                  ),
                                                ),
                                                content: TextField(
                                                  controller: _controller,
                                                  maxLines: 1,
                                                  decoration:
                                                  InputDecoration(
                                                    hintText: widget
                                                        .myuser.pseudo,
                                                    hintStyle: TextStyle(
                                                      fontFamily:
                                                      'Montserrat',
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      color:
                                                      Color(0xff707070),
                                                    ),
                                                    enabledBorder:
                                                    OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                        color: primarycolor,
                                                      ),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(50),
                                                    ),
                                                    focusedBorder:
                                                    OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                        color:
                                                        secondarycolor,
                                                      ),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(50),
                                                    ),
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () =>
                                                        changepseudo(),
                                                    child: Text(
                                                      'Confirmer',
                                                      style: TextStyle(
                                                        fontFamily:
                                                        'Montserrat',
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color: Color(
                                                            0xff707070),
                                                      ),
                                                    ),
                                                  ),
                                                  FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context);
                                                    },
                                                    child: Text(
                                                      'Annuler',
                                                      style: TextStyle(
                                                        fontFamily:
                                                        'Montserrat',
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color: Color(
                                                            0xff707070),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              barrierDismissible: true);
                                        },
                                        child: Text(
                                          widget.myuser.pseudo,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat',
                                            fontSize: 15,
                                            color: Color(0xff707070),
                                          ),
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
                                          top: 15, left: 20.0, right: 10.0),
                                      child: FlatButton(
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    shape:
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            20)),
                                                    contentPadding:
                                                    EdgeInsets.all(15),
                                                    title: Text(
                                                      'changer le tel ',
                                                      style: TextStyle(
                                                        fontFamily:
                                                        'Montserrat',
                                                        fontSize: 19,
                                                        fontWeight:
                                                        FontWeight.w700,
                                                        color: primarycolor,
                                                      ),
                                                    ),
                                                    content: TextField(
                                                      controller: _controller1,
                                                      maxLines: 1,
                                                      decoration:
                                                      InputDecoration(
                                                        hintText:
                                                        widget.myuser.tel,
                                                        hintStyle: TextStyle(
                                                          fontFamily:
                                                          'Montserrat',
                                                          fontSize: 14,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          color:
                                                          Color(0xff707070),
                                                        ),
                                                        enabledBorder:
                                                        OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
                                                            color: primarycolor,
                                                          ),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(50),
                                                        ),
                                                        focusedBorder:
                                                        OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(
                                                            color:
                                                            secondarycolor,
                                                          ),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(50),
                                                        ),
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        onPressed: () =>
                                                            changetel(),
                                                        child: Text(
                                                          'Confirmer',
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'Montserrat',
                                                            fontSize: 12,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            color: Color(
                                                                0xff707070),
                                                          ),
                                                        ),
                                                      ),
                                                      FlatButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Annuler',
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'Montserrat',
                                                            fontSize: 12,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            color: Color(
                                                                0xff707070),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              barrierDismissible: true);
                                        },
                                        child: Text(
                                          widget.myuser.tel == null
                                              ? 'aucun numero'
                                              : widget.myuser.tel,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat',
                                            fontSize: 15,
                                            color: Color(0xff707070),
                                          ),
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
                                          top: 15, left: 40.0, right: 30.0),
                                      child: FlatButton(
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                              //   namedialog(groupe.nom),
                                              AlertDialog(
                                                shape:
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        20)),
                                                contentPadding:
                                                EdgeInsets.all(15),
                                                title: Text(
                                                  "changer l'email",
                                                  style: TextStyle(
                                                    fontFamily:
                                                    'Montserrat',
                                                    fontSize: 19,
                                                    fontWeight:
                                                    FontWeight.w700,
                                                    color: primarycolor,
                                                  ),
                                                ),
                                                content: TextField(
                                                  controller: _controller2,
                                                  maxLines: 1,
                                                  decoration:
                                                  InputDecoration(
                                                    hintText:
                                                    widget.myuser.mail,
                                                    hintStyle: TextStyle(
                                                      fontFamily:
                                                      'Montserrat',
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      color:
                                                      Color(0xff707070),
                                                    ),
                                                    enabledBorder:
                                                    OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                        color: primarycolor,
                                                      ),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(50),
                                                    ),
                                                    focusedBorder:
                                                    OutlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                        color:
                                                        secondarycolor,
                                                      ),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(50),
                                                    ),
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () =>
                                                        changemail(),
                                                    child: Text(
                                                      'confirmer',
                                                      style: TextStyle(
                                                        fontFamily:
                                                        'Montserrat',
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color: Color(
                                                            0xff707070),
                                                      ),
                                                    ),
                                                  ),
                                                  FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context);
                                                    },
                                                    child: Text(
                                                      'annuller',
                                                      style: TextStyle(
                                                        fontFamily:
                                                        'Montserrat',
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color: Color(
                                                            0xff707070),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              barrierDismissible: true);
                                        },
                                        child: Text(
                                          widget.myuser.mail,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Montserrat',
                                            fontSize: 15,
                                            color: Color(0xff707070),
                                          ),
                                        ),
                                      ),

                                    ),

                                  ],
                                ),

                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey[300],
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Colors.grey[200],
                                      blurRadius: 20.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Column(
                            //photos

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
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      new BoxShadow(
                                        color: Colors.grey[200],
                                        blurRadius: 20.0,
                                      ),
                                    ],
                                  ),
                                  child: photoWig(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 110,
                          left: 200,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                // border: Border.all(color: secondarycolor, width: 1),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color:
                                    secondarycolor, //Color.fromRGBO(59, 70, 107, 0.3),
                                    blurRadius: 3.0,
                                    offset: Offset(0.0, 0.75),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(50)),
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.camera_alt,
                                  size: 30.0,
                                ),
                                onPressed: () => showAlertDialog(
                                    context,
                                    "choisissez la source de l'image",
                                    "Source"),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Center(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 60.0,
                                    width: 60.0,
                                    child: Image.asset(
                                      'images/logo.png',
                                      fit: BoxFit.fill,
                                      height: 120.0,
                                      width: 120.0,
                                    ),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ),
                            Center(
                              child: Text(
                                'Compte',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0XFF389490), //vert
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                )),
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
            child: Image.network(
              widget.myuser.photo,
              height: 110.0,
              gaplessPlayback: true,
              fit: BoxFit.fill,
            ),
          ));
    } else {
      return Center(
        child: ListView(
          //photos
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Icon(
              Icons.person,
              color: Color(0xFF5B5050),
              size: 105.0,
            ),
          ],
        ),
      );
    }
  }
// tester si les chaines de caratceres ne sont pas vides


  bool isEditable = false;



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
        authService.userRef
            .document(onValue.uid)
            .updateData({'photo': _uploadedFileURL});
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


  showAlertDialog(BuildContext context, String message, String heading) {
    // set up the buttons
    Widget GalleryButton = FlatButton(
      color: Color(0XFF389490),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(
            color: Color(0XFF389490),
            //vert
          )),
      child: Text(
        'Gallerie',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        updatePic(ImageSource.gallery);
      },
    );
    Widget CameraButton = FlatButton(
      color: Color(0XFF3B466B),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(
            color: Color(0XFF3B466B),
//vert
          )),
      child: Text(
        'Camera',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
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

  Future<bool> pseudoExist(String nom) async {
    final QuerySnapshot result = await Future.value(authService.db
        .collection('Utilisateur')
        .where('pseudo', isEqualTo: nom)
        .limit(1)
        .getDocuments());
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 1) {
      print("UserName Already Exits");
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> mailExist(String nom) async {
    final QuerySnapshot result = await Future.value(authService.db
          .collection('Utilisateur')
          .where('mail', isEqualTo: nom)
          .limit(1)
          .getDocuments());
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 1) {
        print("email Already Exits");
        return true;
      } else {
        print("email is Available");
        return false;
      }
    }

  changepseudo() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      var result2 = await Connectivity().checkConnectivity();
      var b = (result2 != ConnectivityResult.none);

      if (b && result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        nv_pseudo =
            _controller.text;
        setState(() {
          _loading = true;
        });
        if (nv_pseudo != '') {
          await pseudoExist(nv_pseudo).then((value) async {
            if (!value) {
              await authService
                  .changePseudo(
                  widget
                      .myuser
                      .pseudo,
                  nv_pseudo);
            }
            else {
              setState(() {
                _loading = false;
              });
              _showSnackBar('Ce pseudo existe deja, reessayez');
            }
          });
        }
        setState(() {
          _loading = false;
          widget.myuser
              .pseudo =
              nv_pseudo;
        });
        // nv_nom = _controller.text;
        // _confirmer = true;
        Navigator.pop(
            context);
      }
    } on SocketException catch (_) {
      _showSnackBar('Vérifiez votre connexion internet');
    }
  }

  changetel() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      var result2 = await Connectivity().checkConnectivity();
      var b = (result2 != ConnectivityResult.none);

      if (b && result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        nv_tel =
            _controller1.text;
        setState(() {
          _loading = true;
        });
        if (nv_tel != '') {
          if (Validator.number(nv_tel)) {
            String id =
            await authService
                .connectedID();

            if (id != null) {
              await Firestore
                  .instance
                  .collection(
                  'Utilisateur')
                  .document(id)
                  .updateData({
                'tel': nv_tel
              });
            }
          } else {
            _showSnackBar('Veuillez introduire un nombre');
          }
        }
        setState(() {
          _loading = false;
          widget.myuser.tel =
              nv_tel;
        });
        // nv_nom = _controller.text;
        // _confirmer = true;
        Navigator.pop(
            context);
      }
    } on SocketException catch (_) {
      _showSnackBar('Vérifiez votre connexion internet');
    }
  }

  changemail() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      var result2 = await Connectivity().checkConnectivity();
      var b = (result2 != ConnectivityResult.none);

      if (b && result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        nv_mail =
            _controller2.text;
        setState(() {
          _loading = true;
        });
        if (nv_mail != '') {
          if (!Validator.email(nv_mail)) {
            await mailExist(nv_mail).then((value) async {
              if (!value) {
                FirebaseUser id =
                await authService.auth.currentUser();
                if (id != null) {
                  await id.updateEmail(nv_mail).then((value) async {
                    await Firestore
                        .instance
                        .collection(
                        'Utilisateur')
                        .document(id.uid)
                        .updateData({
                      'mail': nv_mail
                    });
                  });
                  setState(() {
                    _loading = false;
                    widget.myuser.mail =
                        nv_mail;
                  });
                }
              } else {
                setState(() {
                  _loading = false;
                });
                _showSnackBar('Cette adresse mail est deja prise');
              }
            });
          } else {
            setState(() {
              _loading = false;
            });
            _showSnackBar('Veuillez introduire une adresse mail valide');
          }
        }

        // nv_nom = _controller.text;
        // _confirmer = true;
        Navigator.pop(
            context);
      }
    } on SocketException catch (_) {
      _showSnackBar('Vérifiez votre connexion internet');
    } catch (e) {
      print(e);
      if (e is PlatformException) {
        if (e.code == 'ERROR_REQUIRES_RECENT_LOGIN') {
          _showSnackBar(
              'Cette operation requiert une authentification recente , reconnectez-vous puis reessayez');
          Navigator.pushNamed(context, LoginScreen.id);
        }
      }
    }
  }
  String mail, pseudo, tel, photo;

  Future userID;
}
