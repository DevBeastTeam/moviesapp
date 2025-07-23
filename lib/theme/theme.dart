import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData appTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  splashColor: ColorsPallet.blueAccent,
  highlightColor: ColorsPallet.blueAccent,
  scrollbarTheme: ScrollbarThemeData(
    interactive: true,
    radius: const Radius.circular(20),
    thumbColor: WidgetStateProperty.all(
      ColorsPallet.blueAccent.withOpacity(0.4),
    ),
    thickness: WidgetStateProperty.all(5),
  ),
  fontFamily: 'Montserrat',
  tooltipTheme: const TooltipThemeData(
    decoration: ShapeDecoration(
      color: Color(0xFF232426),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
  ),
);
