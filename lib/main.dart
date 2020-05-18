import 'package:winek/auth.dart';
import 'package:winek/screensHiba/Aide.dart';
import 'package:device_preview/device_preview.dart';
import 'package:winek/screensHiba/listeFavorisScreen.dart';
import 'package:winek/screensRima/firstLoading.dart';
import 'package:winek/screensRima/login_screen.dart';
import 'package:winek/screensRima/register_screen.dart';
import 'package:winek/screensRima/resetmail.dart';
import 'package:flutter/material.dart';
import 'package:winek/screensSoum/usersListScreen.dart';
import 'package:winek/ui/size_config.dart';
import 'UpdateMarkers.dart';
import 'package:provider/provider.dart';
import 'screensHiba/MapPage.dart';
import 'screensHiba/list_grp.dart';
import 'screensHiba/list_inv_grp.dart';
import 'screensHiba/nouveau_grp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onbroading.dart';

int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  runApp(Winek());
}

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
            initialRoute: initScreen == 0 || initScreen == null
                ? OnboardingScreen.id
                : FirstLoading.id,
            routes: {
              Home.id: (BuildContext context) => Home(),
              LoginScreen.id: (context) => LoginScreen(),
              RegistrationScreen.id: (context) => RegistrationScreen(),
              ResetMailScreen.id: (context) => ResetMailScreen(),
              NvLongTermePage.id: (context) => NvLongTermePage(),
              NvVoyagePage.id: (context) => NvVoyagePage(),
              ListGrpPage.id: (context) => ListGrpPage(),
              InvitationGrpPage.id: (context) => InvitationGrpPage(),
              UsersListScreen.id: (context) => UsersListScreen(),
              FavoritePlacesScreen.id: (context) => FavoritePlacesScreen(),
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
