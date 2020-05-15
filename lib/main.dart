import 'package:winek/auth.dart';
import 'package:winek/screensHiba/Aide.dart';
import 'package:device_preview/device_preview.dart';
import 'package:winek/screensHiba/listeFavorisScreen.dart';
import 'package:winek/screensRima/firstLoading.dart';
import 'package:winek/screensRima/login_screen.dart';
import 'package:winek/screensRima/register_screen.dart';
import 'package:winek/screensRima/resetmail.dart';
import 'package:winek/screensRima/resetpwd_screen.dart';
import 'package:flutter/material.dart';
import 'package:winek/screensSoum/usersListScreen.dart';
import 'package:winek/ui/size_config.dart';
import 'UpdateMarkers.dart';
import 'package:provider/provider.dart';
import 'screensHiba/MapPage.dart';
import 'screensHiba/list_grp.dart';
import 'screensHiba/list_inv_grp.dart';
import 'screensHiba/nouveau_grp.dart';
import 'screensRima/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onbroading.dart';

//void main() => runApp(DevicePreview(builder: (context) => Winek()));
int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen ${initScreen}');
  runApp(Winek());
}

//void main() => runApp(Winek());
Color primarycolor = Color(0xff3B466B);
Color secondarycolor = Color(0xff389490);

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

class Winek extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => UpdateMarkers()),
        ChangeNotifierProvider(
            create: (BuildContext context) => controllermap()),
        ChangeNotifierProvider(
            create: (BuildContext context) => DeviceInformationService()),
        ChangeNotifierProvider(create: (BuildContext context) => AuthService()),
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return MaterialApp(
            builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            //initialRoute: OnboardingScreen.id,
            initialRoute: initScreen == 0 || initScreen == null
                ? OnboardingScreen.id
                : FirstLoading.id,
            routes: {
              Home.id: (BuildContext context) => Home(),
              // la map
              WelcomeScreen.id: (context) => WelcomeScreen(),
              LoginScreen.id: (context) => LoginScreen(),
              RegistrationScreen.id: (context) => RegistrationScreen(),
              ResetScreen.id: (context) => ResetScreen(),
              ResetMailScreen.id: (context) => ResetMailScreen(),
              NvLongTermePage.id: (context) => NvLongTermePage(),
              NvVoyagePage.id: (context) => NvVoyagePage(),
              ListGrpPage.id: (context) => ListGrpPage(),
              InvitationGrpPage.id: (context) => InvitationGrpPage(),
              //FriendRequestListScreen.id: (context) => FriendRequestListScreen(),
              UsersListScreen.id: (context) => UsersListScreen(),
              // FriendsListScreen.id: (context) => FriendsListScreen(),
              FavoritePlacesScreen.id: (context) => FavoritePlacesScreen(),
              // ProfileScreen.id: (context) => ProfileScreen(user),
              FirstLoading.id: (context) => FirstLoading(),
              AidePage.id: (context) => AidePage(),
              OnboardingScreen.id: (context) => OnboardingScreen(),
            },
          );
        });
      }),
    );
  }
}
