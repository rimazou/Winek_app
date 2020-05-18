import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:winek/main.dart';
import 'screensRima/login_screen.dart';

final kTitleStyle = TextStyle(
  color: primarycolor,
  fontFamily: 'Montserrat',
  fontSize: 22,
  fontWeight: FontWeight.w600,
  //height: 1.5,
);

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
  static String id = 'onbroading';
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: responsiveheight(8),
      width: isActive ? responsivewidth(24) : responsivewidth(16),
      decoration: BoxDecoration(
        color: isActive ? primarycolor : secondarycolor,
        borderRadius: BorderRadius.all(
            Radius.circular(responsiveradius(12, 1))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: responsiveheight(10.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                    child: Text(
                      'Passer',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: primarycolor,
                        fontSize: responsivetext(20.0),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: responsiveheight(550),
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          //  crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'images/screen1.jpg',
                                ),
                                height: responsivewidth(350),
                                width: responsivewidth(350),
                              ),
                            ),
                            SizedBox(height: responsiveheight(30)),
                            Center(
                              child: Text(
                                'Repérez-vous où que vous soyez !',
                                style: kTitleStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          //  crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'images/screen2.jpg',
                                ),
                                height: responsivewidth(350.0),
                                width: responsivewidth(350),
                              ),
                            ),
                            SizedBox(height: responsiveheight(30)),
                            Center(
                              child: Text(
                                'Retrouvez vos amis et voyagez ensemble!',
                                style: kTitleStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'images/screen3.jpg',
                                ),
                                height: responsivewidth(350),
                                width: responsivewidth(350),
                              ),
                            ),
                            SizedBox(height: responsiveheight(30)),
                            Center(
                              child: Text(
                                'Échangez des mots et programmez des arrêts !',
                                style: kTitleStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                _currentPage != _numPages - 1
                    ? Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: FlatButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Suivant',
                                  style: TextStyle(
                                    color: secondarycolor,
                                    fontSize: 22.0,
                                  ),
                                ),
                                SizedBox(width: responsivewidth(10)),
                                Icon(
                                  Icons.arrow_forward,
                                  color: secondarycolor,
                                  size: 30.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: responsiveheight(100),
              width: double.infinity,
              color: primarycolor,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                child: Center(
                  child: Text(
                    'Commencer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}
