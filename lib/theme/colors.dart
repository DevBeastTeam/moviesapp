import 'package:flutter/material.dart';

class ColorsPallet {
  ColorsPallet._();

  static const Color darkBlue = Color(0xff0b2845);
  static const Color filmsTabBgColor = Color(0xff0E1B26);
  static const Color blue = Color(0xff14477b);
  static const Color blueAccent = Color(0xff145c97);

  //static const Color blueComponent = Color(0xff2f53a5); //Original
  static const Color blueComponent = Color(0xff457AF2);
  static const Color lightBlueComponent = Color(0xff29bbf9);

  static const Color darkComponentBackground = Color(0x6114477b);
  static const Color borderCardBgColor = Color.fromARGB(116, 24, 44, 63);
  static Color borderCardBorderColor = Colors.grey.shade700;
  static const Color componentBackground = Color(0xff0b2845);
  static const Color componentBackgroundAccent = Color(0xff14477b);

  static const Color shadow = Color(0xff3A64C2);

  static const List<Color> dbba = [
    ColorsPallet.darkBlue,
    ColorsPallet.blueAccent,
  ];

  static const List<Color> bdb = [Colors.black, ColorsPallet.darkBlue];

  static const List<Color> blb = [blueComponent, lightBlueComponent];

  static const Color yellowCA3E = Color(0xffffca3e);
  static const Color yellowBC3A = Color(0xffffbc3a);
  static const Color orangeA031 = Color(0xffffa031);

  static const List<Color> yyo = [yellowCA3E, yellowBC3A, orangeA031];
}
