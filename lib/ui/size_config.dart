import 'package:flutter/material.dart';

class SizeConfig {
  static double screenWidth;

  static double screenHeight;

  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;
  static double textMultiplier;

  static double imageSizeMultiplier;

  static double heightMultiplier;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;
    } else {
      screenWidth = constraints.maxHeight;
      screenHeight = constraints.maxWidth;
    }
    _blockSizeHorizontal = screenWidth / 100;
    _blockSizeVertical = screenHeight / 100;

    textMultiplier = _blockSizeVertical;
    imageSizeMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;
  }
}
