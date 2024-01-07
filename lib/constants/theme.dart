import 'package:flutter/material.dart';

class ThemeConstants {
  static const Color greenPrimaryColor = Color(0xFFACC8A4);
  static const Color greenSecondaryColor = Color(0xFF91B888);

  static const Color yellowPrimaryColor = Color(0xFFE9DCAD);
  static const Color yellowSecondaryColor = Color(0xFFE0CE95);

  static const Color greyPrimaryColor = Color(0xFFF3F3F3);
  static const Color greySecondaryColor = Color(0xFFCECECE);

  static const Color bluePrimaryColor = Color(0xFF7188A8);
  static const Color blueSecondaryColor = Color(0xFF597597);
  static const Color blueDarkColor = Color(0xFF5D677C);

  static const Color purplePrimaryColor = Color(0xFF606586);
  static const Color purpleSecondaryColor = Color(0xFF575978);

  static const Color blackPrimaryColor = Color(0xFF1C1B1F);
  static const Color blackSecondaryColor = Color(0xFF3F3C45);

  static const Color limePrimaryColor = Color(0xFFACC8A4);
  static const Color limeSecondaryColor = Color(0xFF5F9A93);

  static const FontWeight defaultFontWeight = FontWeight.w600;
  static const double defaultFontSize = 18.0;
  static const Color defaultTextColor = ThemeConstants.blackPrimaryColor;

  static const TextStyle defaultTextStyle = TextStyle(
    fontWeight: defaultFontWeight,
    fontSize: defaultFontSize,
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
