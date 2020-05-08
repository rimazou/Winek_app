import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'auth.dart';
import 'package:winek/screensHiba/MapPage.dart';
import 'package:provider/provider.dart';
import 'package:battery/battery.dart';
import 'dart:math' show cos, sqrt, asin;

class UpdateMarkers extends ChangeNotifier {
  Firestore _firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  StreamSubscription<List<DocumentSnapshot>> stream;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Marker _marker;
  GoogleMapController _controller;
  double dest_lat;
  double dest_lng;
  BuildContext mapcontext;
  var val;

  static double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void UpdateusersLocation(String path, BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    mapcontext = context;
    val = await authService.connectedID();
    var collectionReference = _firestore.document(path).collection('members');
    LatLng lemis = new LatLng(36.6178786, 2.3912362);
    GeoFirePoint geoFPointl =
        geo.point(latitude: lemis.latitude, longitude: lemis.longitude);
    LatLng latLng = new LatLng(geoFPointl.latitude, geoFPointl.longitude);

    marker_dest(path);
    double radius = 50;
    String field = 'position';
    stream = geo
        .collection(collectionRef: collectionReference)
        .within(center: geoFPointl, radius: radius, field: field)
        .listen(_updateMarkers);
  }

  void marker_dest(String chemin) async {
    await _firestore.document(chemin).get().then((DocumentSnapshot ds) {
      dest_lat = ds.data['destination']['latitude'];
    });
    await _firestore.document(chemin).get().then((DocumentSnapshot ds) {
      dest_lng = ds.data['destination']['longitude'];
    });
    MarkerId id = MarkerId(dest_lat.toString() + dest_lng.toString());
    _marker = Marker(
      markerId: id,
      position: LatLng(dest_lat, dest_lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      infoWindow: InfoWindow(title: 'destination'),
    );

    markers[id] = _marker;
    notifyListeners();
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) async {
    LatLng latlng;
    CameraUpdate cameraUpdate;

    documentList.forEach((DocumentSnapshot document) async {
      String userid = document.documentID;
      markers.remove(MarkerId(userid));
      GeoPoint point = document.data['position']['geopoint'];
      if (val == userid) {
        latlng = new LatLng(point.latitude, point.longitude);
        cameraUpdate = CameraUpdate.newLatLngZoom(latlng, 12);
        Provider.of<controllermap>(mapcontext, listen: false)
            .mapController
            .animateCamera(cameraUpdate);
      }
      _addMarker(point.latitude, point.longitude, userid);
    });
  }

  Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);
    final Paint shadowPaint = Paint()..color = Color(0x96389490);
    final double shadowWidth = 25.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    final double borderWidth = 3.0;

    final double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowPaint);

    // Add border circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(shadowWidth, shadowWidth,
              size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint);

    // Oval for the image
    Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        size.width - (imageOffset * 2), size.height - (imageOffset * 2));

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    // Add image
    ui.Image image = await getImage(imagePath);

    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fill);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);

    final Uint8List uint8List = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  Future<ui.Image> getImage(String path) async {
    Completer<ImageInfo> completer = Completer();
    var img = new NetworkImage(path);
    img
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      if (!completer.isCompleted) {
        completer.complete(info);
      }
    }));
    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }

  Future<void> _addMarker(double lat, double lng, String usrid) async {
    MarkerId id = MarkerId(usrid);

    String url;
    await _firestore
        .collection('Utilisateur')
        .document(usrid)
        .get()
        .then((DocumentSnapshot ds) {
      url = ds.data['photo'];
    });

    _marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      icon: await getMarkerIcon(url, Size(200.0, 200.0)),
      //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      //infoWindow: InfoWindow(title: 'distance', snippet: '$distance'),
    );

    markers[id] = _marker;
    notifyListeners();
  }
}

class DeviceInformationService extends ChangeNotifier {
  bool _broadcastBattery = false;
  Battery _battery = Battery();
  int batteryLvl = 100;

  Future broadcastBatteryLevel(String id) async {
    _broadcastBattery = true;
    while (_broadcastBattery) {
      batteryLvl = await _battery.batteryLevel;
      notifyListeners();
      Firestore.instance
          .collection('Utilisateur')
          .document(id)
          .updateData({'batterie': batteryLvl});
      await Future.delayed(Duration(seconds: 5));
    }
  }

  void stopBroadcast() {
    _broadcastBattery = false;
  }
}

// body:Text('${Provider.of<DeviceInformationService>(context).batteryLvl}'),
/* body:StreamBuilder(
         stream:_firestore.collection('Utilisateur').document().snapshots(),
         builder:(context,snapshot){
           if(!snapshot.hasData)
           return Text('Loading data ... please wait');
           return Text('Le niveau de batterie est : ${snapshot.data['baterie']}');
         } ,
         ),*/
/*
Future<double> getDistance(Position position, LatLng dest)async{
  double distanced= await Geolocator().distanceBetween(position.latitude, position.longitude,dest.latitude, dest.longitude);
  return distanced;
}

double getSpeed(String groupeid, String id) {
  StreamBuilder(
    stream:
        Firestore.instance.collection('Utilisateur').document(id).snapshots(),
    builder: (context, snapshot) {
      return Text(
        '${snapshot.data['batterie']}%',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
        ),
      );
    },
  );
  double speed = position.speed;
  return speed;
}
*/
