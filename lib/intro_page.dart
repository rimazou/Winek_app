import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as Math;
import 'package:flutter/widgets.dart';
import 'package:winek/main.dart';
import 'dart:math';
import 'screensRima/welcome_screen.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
  static String id = 'IntroPage';
}

class _IntroPageState extends State<IntroPage> {
  List<String> nameImages = [
    'images/logo.png',
    'images/logo.png',
    'images/logo.png',
    'images/logo.png',
  ];

  List<String> nameTitles = [
    '',
    '',
    '',
    '',
  ];

  List<String> nameSubTitles = [
    'Browse the menu and order directly from the application',
    'Your order will be immediately collected and',
    'Pick up delivery at your door and enjoy groceries',
    'Browse the menu and order directly from the application'
  ];

  final int _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  double progressPercent = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.,
                  children: [
                    Spacer(
                      flex: 1,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: () {
                          print('Skip');
                          Navigator.pushNamed(context, WelcomeScreen.id);
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(color: primarycolor, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 500.0,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                        //progressPercent = (_currentPage + 1) * 1.0/_numPages;
                      });
                    },
                    children: _buildListContentPage(),
                  ),
                ),
                _customProgress(),
                _buildNextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return (_currentPage != _numPages - 1
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
//                    Text(
//                      'Next',
//                      style: TextStyle(
//                        color: Colors.black,
//                        fontSize: 22.0,
//                      ),
//                    ),
                  ],
                ),
              ),
            ),
          )
        : Expanded(
            child: Align(
              alignment: FractionalOffset.bottomRight,
              child: FlatButton(
                onPressed: () {
                  print('Start');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
//                    Text(
//                      'Start',
//                      style: TextStyle(
//                        color: Colors.black,
//                        fontSize: 22.0,
//                      ),
//                    ),
                  ],
                ),
              ),
            ),
          ));
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24 : 16,
      decoration: BoxDecoration(
        color: isActive ? primarycolor : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _customProgress() {
    return Stack(
      alignment: Alignment.center,
      children: [
//        CustomPaint(
//            foregroundPainter: CircleProgress((_currentPage + 1) * 100 / _numPages),
//            // this will add custom painter after child
//            child: Container(
//                width: 90,
//                height: 90,
//                child: GestureDetector(
//                  onTap: () {},
//                ))),
        Container(
          width: 80,
          height: 80,
          child: CircleProgressBar(
            backgroundColor: Colors.white,
            foregroundColor: secondarycolor,
            value: ((_currentPage + 1) * 1.0 / _numPages),
          ),
        ),
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: secondarycolor,
          ),
          child: IconButton(
            onPressed: () {
              _pageController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            iconSize: 15,
          ),
        )
      ],
    );
  }

  List<Widget> _buildListContentPage() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(
        _buildMainContent(nameImages[i], nameTitles[i], nameSubTitles[i]),
      );
    }
    return list;
  }

  Padding _buildMainContent(
      String nameImage, String nameTitle, String nameSubTitle) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image(
              image: AssetImage(nameImage),
              height: 300.0,
              width: 300.0,
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Text(
            nameTitle,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: primarycolor,
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              nameSubTitle,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xff707070),
              ),
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }
}

class CircleProgress extends CustomPainter {
  double currentProgress;

  CircleProgress(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {
    //this is base circle
    Paint outerCircle = Paint()
      ..strokeWidth = 3
      ..color = Colors.white
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 3
      ..color = secondarycolor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 10;

    canvas.drawCircle(
        center, radius, outerCircle); // this draws main outer circle

    double angle = 2 * pi * (currentProgress / 100);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

/// Draws a circular animated progress bar.
class CircleProgressBar extends StatefulWidget {
  final Duration animationDuration;
  final Color backgroundColor;
  final Color foregroundColor;
  final double value;

  const CircleProgressBar({
    Key key,
    this.animationDuration,
    this.backgroundColor,
    @required this.foregroundColor,
    @required this.value,
  }) : super(key: key);

  @override
  CircleProgressBarState createState() {
    return CircleProgressBarState();
  }
}

class CircleProgressBarState extends State<CircleProgressBar>
    with SingleTickerProviderStateMixin {
  // Used in tweens where a backgroundColor isn't given.
  static const TRANSPARENT = Color(0x00000000);
  AnimationController _controller;

  Animation<double> curve;
  Tween<double> valueTween;
  Tween<Color> backgroundColorTween;
  Tween<Color> foregroundColorTween;

  @override
  void initState() {
    super.initState();

    this._controller = AnimationController(
      duration: this.widget.animationDuration ?? const Duration(seconds: 1),
      vsync: this,
    );

    this.curve = CurvedAnimation(
      parent: this._controller,
      curve: Curves.easeInOut,
    );

    // Build the initial required tweens.
    this.valueTween = Tween<double>(
      begin: 0,
      end: this.widget.value,
    );

    this._controller.forward();
  }

  @override
  void didUpdateWidget(CircleProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (this.widget.value != oldWidget.value) {
      // Try to start with the previous tween's end value. This ensures that we
      // have a smooth transition from where the previous animation reached.
      double beginValue =
          this.valueTween?.evaluate(this.curve) ?? oldWidget?.value ?? 0;

      // Update the value tween.
      this.valueTween = Tween<double>(
        begin: beginValue,
        end: this.widget.value ?? 1,
      );

      // Clear cached color tweens when the color hasn't changed.
      if (oldWidget?.backgroundColor != this.widget.backgroundColor) {
        this.backgroundColorTween = ColorTween(
          begin: oldWidget?.backgroundColor ?? TRANSPARENT,
          end: this.widget.backgroundColor ?? TRANSPARENT,
        );
      } else {
        this.backgroundColorTween = null;
      }

      if (oldWidget.foregroundColor != this.widget.foregroundColor) {
        this.foregroundColorTween = ColorTween(
          begin: oldWidget?.foregroundColor,
          end: this.widget.foregroundColor,
        );
      } else {
        this.foregroundColorTween = null;
      }

      this._controller
        ..value = 0
        ..forward();
    }
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBuilder(
        animation: this.curve,
        child: Container(),
        builder: (context, child) {
          final backgroundColor =
              this.backgroundColorTween?.evaluate(this.curve) ??
                  this.widget.backgroundColor;
          final foregroundColor =
              this.foregroundColorTween?.evaluate(this.curve) ??
                  this.widget.foregroundColor;

          return CustomPaint(
            child: child,
            foregroundPainter: CircleProgressBarPainter(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              percentage: this.valueTween.evaluate(this.curve),
            ),
          );
        },
      ),
    );
  }
}

// Draws the progress bar.
class CircleProgressBarPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final Color backgroundColor;
  final Color foregroundColor;

  CircleProgressBarPainter({
    this.backgroundColor,
    @required this.foregroundColor,
    @required this.percentage,
    double strokeWidth,
  }) : this.strokeWidth = strokeWidth ?? 3;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final Size constrainedSize =
        size - Offset(this.strokeWidth, this.strokeWidth);
    final shortestSide =
        Math.min(constrainedSize.width, constrainedSize.height);
    final foregroundPaint = Paint()
      ..color = this.foregroundColor
      ..strokeWidth = this.strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final radius = (shortestSide / 2);

    // Start at the top. 0 radians represents the right edge
    final double startAngle = -(2 * Math.pi * 0.25);
    final double sweepAngle = (2 * Math.pi * (this.percentage ?? 0));

    // Don't draw the background if we don't have a background color
    if (this.backgroundColor != null) {
      final backgroundPaint = Paint()
        ..color = this.backgroundColor
        ..strokeWidth = this.strokeWidth
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, backgroundPaint);
    }

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final oldPainter = (oldDelegate as CircleProgressBarPainter);
    return oldPainter.percentage != this.percentage ||
        oldPainter.backgroundColor != this.backgroundColor ||
        oldPainter.foregroundColor != this.foregroundColor ||
        oldPainter.strokeWidth != this.strokeWidth;
  }
}
