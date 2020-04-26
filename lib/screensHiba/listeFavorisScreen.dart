import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import '../dataBaseDounia.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'listeFavoris.dart';
import '../main.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey:"AIzaSyBV4k4kXJRfG5RmCO3OF24EtzEzZcxaTrg");
class  FavoritePlacesScreen extends StatefulWidget {
  static const String id = 'FavoritePlacesScreen';
  @override
 _FavoritePlacesScreenState createState() => _FavoritePlacesScreenState();
}

class _FavoritePlacesScreenState extends State<FavoritePlacesScreen> {

 
//static final currentUser = 'oHFzqoSaM4RUDpqL9UF396aTCf72';

  @override
  Widget build(BuildContext context) {

    return StreamProvider<List<dynamic>>.value(
     value: DataBaseFavoris().getlistfavoris,
      child : GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child : SafeArea(child:Scaffold(
          resizeToAvoidBottomInset: false,
         /* appBar: AppBar(
            backgroundColor: Colors.white30,
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Colors.black54,),
            actions: <Widget>[ IconButton(
              onPressed: () {
               // Navigator.pushNamed(context, FriendRequestListScreen.id);
              },
              icon: Icon(Icons.arrow_back),
              color: Color(0xFF707070),
              iconSize: 35.0,),],
          ),*/
          body: Center(

            child: Column(
              children: <Widget> [ 
                Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                 icon:Icon(Icons.arrow_back,color:Color(0xFF707070),),
                 iconSize: 35,
               onPressed: (){
              
                },
              ),
                ), 
                Center(
                 child : Text(
                  'Endroits favoris',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF389490),
                    fontFamily: 'Montserrat-Bold',),),),

                Spacer(flex:1),
                Container(
                  height:  450.0,
                  width: 350.0,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:  Color(0xFFD0D8E2),),
                  child:  FavorisList(),),
                Spacer(flex:1),
                IconButton(
                 icon:Icon(Icons.add_circle_outline,color:Color(0xFF389490),),
                 iconSize: 35,
               onPressed:()async{

    // show input autocomplete with selected mode
    // then get the Prediction selected
     Prediction p = await PlacesAutocomplete.show(
        context: context,
      apiKey: "AIzaSyBV4k4kXJRfG5RmCO3OF24EtzEzZcxaTrg",
      onError: onError,
      mode: Mode.overlay,
      language: "fr",
      components: [Component(Component.country, "DZ")],
      
    );

    displayPrediction(p);
  },
               
              
                
              ),
              
              Spacer(flex: 1,)
              ],),
          ),),
      ),
      ),
    );   
  }
  
}
 Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      
      print('Place id : $placeId');
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      //var address = await Geocoder.local.findAddressesFromQuery(p.description);
 //mapController.animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
        //mapController.animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
             Geoflutterfire g= Geoflutterfire();
                GeoFirePoint gp= g.point(latitude:lat, longitude:lng); 
                DataBaseFavoris().favorisUpdateData(gp);
           /* mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
          LatLng(lat,lng),
          zoom: 14.0)));*/
      print(lat);
      print(lng);
    }
 }
   final homeScaffoldKey = GlobalKey<ScaffoldState>();

     void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }