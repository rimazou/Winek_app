import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:winek/ui/size_config.dart';
import '../classes.dart';

var _controller;
var _controller1;
var _controller2;
String nv_pseudo;
String nv_tel;
String nv_mail;
bool _loading;

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile';
  final Utilisateur myuser;

  ProfileScreen(this.myuser);

  @override
  _ProfileScreenState createState() => _ProfileScreenState(myuser);
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseUser loggedInUser;
  final GlobalKey<ScaffoldState> _profilekey = new GlobalKey<ScaffoldState>();

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

  showSBar(String value, BuildContext context) {
    _profilekey.currentState.showSnackBar(SnackBar(
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

    )
    );
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
            body: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: responsivewidth(0.0),
                    vertical: responsiveheight(0.0)),
                child: Container(
                  child: SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: responsiveheight(230),
                            ),
                            Container(
                              // carre principal
                              child: Container(
                                height: responsiveheight(450),
                                // carre principal
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: responsiveheight(140),),

                                    Container(
                                      child: FlatButton(
                                        padding: EdgeInsets.all(0),
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
                                                        responsiveradius(
                                                            20, 1))),
                                                contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: responsiveheight(
                                                        15),
                                                    vertical: responsivewidth(
                                                        15)),
                                                title: Text(
                                                  'Changer le pseudo ',
                                                  style: TextStyle(
                                                    fontFamily:
                                                    'Montserrat',
                                                    fontSize: responsivetext(
                                                        19),
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
                                                      fontSize: responsivetext(
                                                          14),
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
                                                        fontSize: responsivetext(
                                                            12),
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
                                                        fontSize: responsivetext(
                                                            12),
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
                                        child: Card(
                                          color: Colors.white,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 25.0),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.account_box,
                                              color: Color(0xFF3b466b),
                                              size: 25.0,
                                            ),
                                            title: Text(widget.myuser.pseudo,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Montserrat',
                                                fontSize: responsivetext(18),
                                                color: Color(0xff707070),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ),

                                    Container(
//
                                      child: FlatButton(
                                        padding: EdgeInsets.all(0),

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
                                                    EdgeInsets.symmetric(
                                                        vertical: responsiveheight(
                                                            15),
                                                        horizontal: responsivewidth(
                                                            15)),
                                                    title: Text(
                                                      'changer le tel ',
                                                      style: TextStyle(
                                                        fontFamily:
                                                        'Montserrat',
                                                        fontSize: responsivetext(
                                                            19),
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
                                                          fontSize: responsivetext(
                                                              14),
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
                                                            fontSize: responsivetext(
                                                                12),
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
                                                            fontSize: responsivetext(
                                                                12),
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
                                        child: Card(
                                          color: Colors.white,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 25.0),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.phone,
                                              color: Color(0xFF3b466b),
                                              size: 25.0,
                                            ),
                                            title: Text(
                                              widget.myuser.tel == null
                                                  ? 'aucun numero'
                                                  : widget.myuser.tel,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Montserrat',
                                                fontSize: responsivetext(18),
                                                color: Color(0xff707070),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ),
                                    Container(

                                      child: FlatButton(
                                        padding: EdgeInsets.all(0),
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
                                                EdgeInsets.symmetric(
                                                    horizontal: responsivewidth(
                                                        15),
                                                    vertical: responsiveheight(
                                                        15)),
                                                title: Text(
                                                  "changer l'email",
                                                  style: TextStyle(
                                                    fontFamily:
                                                    'Montserrat',
                                                    fontSize: responsivetext(
                                                        19),
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
                                                      fontSize: responsivetext(
                                                          14),
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
                                                        fontSize: responsivetext(
                                                            12),
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
                                                        fontSize: responsivetext(
                                                            12),
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
                                        child: Card(
                                          color: Colors.white,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 25.0),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.mail,
                                              color: Color(0xFF3b466b),
                                              size: 25.0,
                                            ),
                                            title: Text(
                                              widget.myuser.mail,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Montserrat',
                                                fontSize: responsivetext(18),
                                                color: Color(0xff707070),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFd0d8e2),
                                borderRadius: BorderRadius.only(
                                  topRight: const Radius.circular(20),
                                  topLeft: const Radius.circular(20),
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.blueGrey,
                                      blurRadius: 3.0,
                                      offset: Offset(responsivewidth(0.0),
                                          responsiveheight(0.75))
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        //la photo
                        Center(
                          child: Column(
                            //photos

                            children: <Widget>[
                              SizedBox(
                                height: responsiveheight(170),
                              ),
                              Center(
                                child: Container(
                                  height: responsiveheight(130),
                                  width: responsiveheight(130),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey[300],
                                      width: responsivewidth(3),
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        responsiveradius(20, 100)),
                                    boxShadow: [
                                      new BoxShadow(
                                        color: Colors.grey[200],
                                        blurRadius: responsiveradius(20.0, 1),
                                      ),
                                    ],
                                  ),
                                  child: photoWig(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //changer la photo
                        Positioned(
                          top: responsiveheight(150),
                          left: (MediaQuery
                              .of(context)
                              .size
                              .width * 0.5) -
                              responsivewidth(47) * 0.5 +
                              responsiveheight(120) * 0.5,
                          // left: responsivewidth(203),
                          child: Container(
                            //padding: EdgeInsets.all(1),
                            width: responsivewidth(47),
                            height: responsivewidth(47),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                // border: Border.all(color: secondarycolor, width: 1),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: secondarycolor,
                                      //Color.fromRGBO(59, 70, 107, 0.3),
                                      blurRadius: responsiveradius(3.0, 1),
                                      //offset: Offset(0.0, 0.75),
                                      offset: Offset(responsivewidth(0.0),
                                          responsiveheight(0.75))),
                                ],
                                borderRadius: BorderRadius.circular(
                                    responsiveradius(50, 1))),
                            child: Padding(
                              padding: EdgeInsets.all(responsivewidth(0.1)),
                              child: IconButton(
                                icon: Icon(
                                  Icons.camera_alt,
                                  size: responsivewidth(30),
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
                            SizedBox(height: responsiveheight(20),),
                            Center(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: responsivewidth(30.0),
                                    width: responsivewidth(30.0),
                                    child: Image.asset(
                                      'images/logo.png',
                                      fit: BoxFit.fill,
                                      height: responsivewidth(120.0),
                                      width: responsivewidth(120.0),
                                    ),
                                  ),
                                  SizedBox(width: 2,),
                                  Text(
                                    'inek',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: responsivetext(20.0),
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
                                  fontSize: responsivetext(30.0),
                                  fontWeight: FontWeight.w600,
                                  color: Color(0XFF389490), //vert
                                ),
                              ),
                            ),
                          ],
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
            borderRadius: BorderRadius.circular(responsiveradius(17.0, 110)),
            child: Image.network(
              widget.myuser.photo,
              height: responsiveheight(140),
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
              height: responsiveheight(16),
            ),
            Icon(
              Icons.person,
              color: Color(0xFF5B5050),
              size: responsivewidth(105),
            ),
          ],
        ),
      );
    }
  }
// tester si les chaines de caratceres ne sont pas vides


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
        maxHeight: responsiveheight(110).toInt(),
        maxWidth: responsiveheight(110).toInt(),
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
    } else {
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
        nv_pseudo = _controller.text;
        setState(() {
          _loading = true;
        });
        if (nv_pseudo != '') {
          await pseudoExist(nv_pseudo).then((value) async {
            if (!value) {
              await authService.changePseudo(widget.myuser.pseudo, nv_pseudo);
              Navigator.pop(context);
              setState(() {
                _loading = false;
                widget.myuser.pseudo = nv_pseudo;
              });
            } else {
              Navigator.pop(context);
              setState(() {
                _loading = false;
              });
              showSBar('Ce pseudo existe deja, reessayez', context);
              print('psueod exist deja');
            }
          });
        }
        setState(() {
          _loading = false;
        });
        // nv_nom = _controller.text;
        // _confirmer = true;

      }
    } on SocketException catch (_) {
      setState(() {
        _loading = false;
      });
      showSBar('Vérifiez votre connexion internet', context);
      print('verifiez internet');
    }
  }

  changetel() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      var result2 = await Connectivity().checkConnectivity();
      var b = (result2 != ConnectivityResult.none);

      if (b && result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        nv_tel = _controller1.text;
        setState(() {
          _loading = true;
        });
        if (nv_tel != '') {
          if (!Validator.number(nv_tel)) {
            String id = await authService.connectedID();

            if (id != null) {
              await Firestore.instance
                  .collection('Utilisateur')
                  .document(id)
                  .updateData({'tel': nv_tel});
              setState(() {
                _loading = false;
                widget.myuser.tel = nv_tel;
              });
              Navigator.pop(context);
            }
          } else {
            Navigator.pop(context);
            showSBar('Veuillez introduire un nombre', context);
          }
        }
        setState(() {
          _loading = false;
        });
        // nv_nom = _controller.text;
        // _confirmer = true;

      }
    } on SocketException catch (_) {
      showSBar('Vérifiez votre connexion internet', context);
    }
  }

  changemail() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      var result2 = await Connectivity().checkConnectivity();
      var b = (result2 != ConnectivityResult.none);

      if (b && result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        nv_mail = _controller2.text;
        setState(() {
          _loading = true;
        });
        if (nv_mail != '') {
          if (!Validator.email(nv_mail)) {
            await mailExist(nv_mail).then((value) async {
              if (!value) {
                FirebaseUser id = await authService.auth.currentUser();
                if (id != null) {
                  await id.updateEmail(nv_mail).then((value) async {
                    await Firestore.instance
                        .collection('Utilisateur')
                        .document(id.uid)
                        .updateData({'mail': nv_mail});
                  });
                  setState(() {
                    _loading = false;
                    widget.myuser.mail = nv_mail;
                  });
                  Navigator.pop(context);
                }
              } else {
                Navigator.pop(context);
                setState(() {
                  _loading = false;
                });
                showSBar('Cette adresse mail est deja prise', context);
              }
            });
          } else {
            Navigator.pop(context);
            setState(() {
              _loading = false;
            });
            showSBar('Veuillez introduire une adresse mail valide', context);
          }
        }

        // nv_nom = _controller.text;
        // _confirmer = true;
      }
    } on SocketException catch (_) {
      Navigator.pop(context);
      showSBar('Vérifiez votre connexion internet', context);
    } catch (e) {
      print(e);
      if (e is PlatformException) {
        if (e.code == 'ERROR_REQUIRES_RECENT_LOGIN') {
          showSBar(
              'Cette operation requiert une authentification recente , reconnectez-vous puis reessayez',
              context);
          Navigator.pushNamed(context, LoginScreen.id);
        }
      }
    }
  }

  String mail, pseudo, tel, photo;

  double responsivetext(double siz) {
    return (siz / 6.92) * SizeConfig.textMultiplier;
  }

  double responsiveheight(double height) {
    return (height / 6.92) * SizeConfig.heightMultiplier;
  }

  double responsivewidth(double width) {
    return (width / 3.6) * SizeConfig.imageSizeMultiplier;
  }

  double responsiveradius(double rad, double height) {
    return (rad / height) * responsiveheight(height);
  }

  Future userID;
}
