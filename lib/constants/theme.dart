import 'package:flutter/material.dart';

import '../models/player_model.dart';

class ThemeConstants {
  static const Color greenPrimaryColor = Color(0xFF3EDC81);
  static const Color greenSecondaryColor = Color(0xFF1FA85B);

  static const Color yellowPrimaryColor = Color(0xFFFFD23F);
  static const Color yellowSecondaryColor = Color(0xFFE39B0B);

  static const Color greyPrimaryColor = Color(0xFFFBFAFF);
  static const Color greySecondaryColor = Color(0xFFC3C6E4);

  static const Color bluePrimaryColor = Color(0xFF3355E0);
  static const Color blueSecondaryColor = Color(0xFF2440B8);
  static const Color blueDarkColor = Color(0xFF5D677C);

  static const Color purplePrimaryColor = Color(0xFF8A3DF0);
  static const Color purpleSecondaryColor = Color(0xFF6520C4);

  static const Color blackPrimaryColor = Color(0xFF1B1830);
  static const Color blackSecondaryColor = Color(0xFF0B0918);

  static const Color limePrimaryColor = Color(0xFF4FE3FF);
  static const Color limeSecondaryColor = Color(0xFF159BC4);

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
  static const double defaultBorderRadius = 20.0;

  /// Height of the darker edge under raised surfaces, which replaces the
  /// thick borders: it reads as a button and sinks when pressed.
  static const double lipHeight = 6.0;

  static const double defaultIconSize = 48.0;

  static const Duration defaultDuration = Duration(milliseconds: 300);
  static const Curve defaultCurve = Curves.easeOutCirc;

  static const Duration entranceDuration = Duration(milliseconds: 450);
  static const Curve bounceCurve = Curves.easeOutBack;

  /// Blends [color] with white to get a brighter shade of the same hue.
  static Color lighten(Color color, [double amount = 0.2]) {
    return Color.lerp(color, Colors.white, amount)!;
  }

  /// Soft diagonal gradient used on every coloured surface.
  static LinearGradient surfaceGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [lighten(color, 0.16), color],
    );
  }
}

extension TeamColors on Team {
  Color get color => this == Team.green
      ? ThemeConstants.greenPrimaryColor
      : ThemeConstants.yellowPrimaryColor;

  Color get borderColor => this == Team.green
      ? ThemeConstants.greenSecondaryColor
      : ThemeConstants.yellowSecondaryColor;

  Team get opponent => this == Team.green ? Team.yellow : Team.green;
}
