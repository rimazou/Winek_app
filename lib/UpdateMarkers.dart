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

class UpdateMarkers extends ChangeNotifier {
  Firestore _firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  StreamSubscription<List<DocumentSnapshot>> stream;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Marker _marker;
  GoogleMapController _controller;
  var val = authService.connectedID();

  void UpdateusersLocation(String path) async{
    var collectionReference = _firestore.document(path).collection('members');
    
    markers.clear();

    LatLng lemis = new LatLng(36.6178786, 2.3912362);
    GeoFirePoint geoFPointl =
        geo.point(latitude: lemis.latitude, longitude: lemis.longitude);
    
   // GeoFirePoint geoFPointl ;
   /*await collectionReference.document(val).get().then((DocumentSnapshot ds)
   {
      geoFPointl=ds.data['location'];
   });*/
    // CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(latLng, 12);
    // _controller.animateCamera(cameraUpdate);

    double radius = 50;
    String field = 'position';
    stream = geo
        .collection(collectionRef: collectionReference)
        .within(center: geoFPointl, radius: radius, field: field)
        .listen(_updateMarkers);
  }


  void _updateMarkers(List<DocumentSnapshot> documentList) async {
    LatLng latlng;
    CameraUpdate cameraUpdate;
    documentList.forEach((DocumentSnapshot document) async {
      String userid = document.data['userID'];
      markers.remove(MarkerId(userid));
      GeoPoint point = document.data['position']['geopoint'];
      /*  if(val==document.documentID)
      {
        latlng = new LatLng(point.latitude,point.longitude);
          cameraUpdate = CameraUpdate.newLatLngZoom(latlng,12);
         _controller.animateCamera(cameraUpdate);
      }*/
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

  Completer<ImageInfo> completer = Completer();

  Future<ui.Image> getImage(String path) async {
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
    /*await _firestore.collection('Utilisateur').document(usrid).get().then((DocumentSnapshot ds)
   {
      url=ds.data['photo'];
   });*/
    _marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      icon: await getMarkerIcon(
          "https://firebasestorage.googleapis.com/v0/b/winek-70176.appspot.com/o/photos%2FScreenshot_20200410-202649_Drive.jpg%7D?alt=media&token=422603f8-8f32-4292-9463-5af67345e1db",
          Size(200.0, 200.0)),
      //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      //infoWindow: InfoWindow(title: 'distance', snippet: '$distance'),
    );

    markers[id] = _marker;
    notifyListeners();
  }
}
