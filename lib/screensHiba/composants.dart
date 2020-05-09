import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({this.colour, this.title,@required this.onPressed });

  final Color colour;
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:MainAxisAlignment.center,
      children:<Widget>[ Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Material(
          color: colour,
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          elevation: 5.0,
          child: MaterialButton(
            onPressed: onPressed,
            minWidth: 320.0,
            height: 35.0,
            child: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),],
    );
  }
}