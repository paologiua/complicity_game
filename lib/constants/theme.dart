import 'package:flutter/material.dart';

class ThemeConstants {
  static const Color greenPrimaryColor = Color(0xFFB2C9AB);
  static const Color greenSecondaryColor = Color(0xFFA6C19F);

  static const Color yellowPrimaryColor = Color(0xFFE8DDB5);
  static const Color yellowSecondaryColor = Color(0xFFE3D3A1);

  static const Color greyPrimaryColor = Color(0xFFD9D9D9);
  static const Color greySecondaryColor = Color(0xFFC0C0C0);

  static const Color bluePrimaryColor = Color(0xFF788AA3);
  static const Color blueSecondaryColor = Color(0xFF6D819A);

  static const Color purplePrimaryColor = Color(0xFF666A86);
  static const Color purpleSecondaryColor = Color(0xFF62647E);

  static const Color defaultTextColor = Color(0xFF1C1B1F);
  static const TextStyle defaultTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18.0,
    color: defaultTextColor,
  );

  static const double defaultMaxWidth = 350.0;
  static const double defaultPadding = 20.0;
  static const double defaultBorder = 20.0;
  static const double defaultBorderRadius = 20.0;

  static const double defaultIconSize = 48.0;

  static const Duration defaultDuration = Duration(milliseconds: 300);
  static const Curve defaultCurve = Curves.easeOutCirc;
}
