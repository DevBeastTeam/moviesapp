import 'package:flutter/material.dart';

class ScreenUtils {
  final BuildContext context;

  ScreenUtils(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  bool get isTablet {
    // Using shortestSide is more reliable for tablet detection
    // across orientations.
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide > 600;
  }

  bool get isLandscape => width > height;

  bool get isPhone => !isTablet;
}
