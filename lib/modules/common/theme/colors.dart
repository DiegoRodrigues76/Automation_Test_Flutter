import 'package:flutter/material.dart';

class ZemaColors {
  // Auxiliaries colors
  static const Color error = Color(0xFFD75A5A);
  static const Color success = Color(0xFFAADB1E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // Grey colors
  static const Color grey = Color(0xFF343A40);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF343A40);

  // Blue colors
  static const Color blue = Color(0xFF132E3E);
  static const Color lightBlue = Color(0xFFECF8FF);
  static const Color darkBlue = Color(0xFF091F2C);

  // Yellow colors
  static const Color yellow = Color(0xFFFFCD00);
  static const Color lightYellow = Color(0xFFFFE066);
  static const Color darkYellow = Color(0xFFFFCD00);

  static const Color coolGray = Color(0xFFDBDCDC);
  static const Color blackColor = Color.fromARGB(255, 79, 79, 80);
  static const Color accentGray = Color.fromARGB(255, 223, 223, 223);
  static const Color disableGray = Color.fromARGB(255, 167, 167, 167);

  //Green colors
  static const Color green1 = Color(0xFFAADB1E); // RGB: 170, 219, 30
  static const Color green2 = Color(0xFFCCDB26); // RGB: 204, 219, 38
  // Primaries colors
  static const Color primary = darkBlue;
  static const Color secondary = blue;
  static const Color tertiary = yellow;
  static const MaterialColor primarySwatch = MaterialColor(
    400,
    {
      50: primary,
      100: primary,
      200: primary,
      300: primary,
      400: primary,
      500: primary,
      600: primary,
      700: primary,
      800: primary,
      900: primary,
    },
  );
}
