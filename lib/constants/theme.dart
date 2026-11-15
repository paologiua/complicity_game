import 'package:flutter/material.dart';

import '../models/player_model.dart';

class ThemeConstants {
  static const Color greenPrimaryColor = Color(0xFF8EE5A8);
  static const Color greenSecondaryColor = Color(0xFF3FAE66);

  static const Color yellowPrimaryColor = Color(0xFFFFDB6E);
  static const Color yellowSecondaryColor = Color(0xFFDFA11C);

  static const Color greyPrimaryColor = Color(0xFFFFFFFF);
  static const Color greySecondaryColor = Color(0xFFEBC6A0);

  static const Color bluePrimaryColor = Color(0xFFA9C8FF);
  static const Color blueSecondaryColor = Color(0xFF5B8DEF);
  static const Color blueDarkColor = Color(0xFF5D677C);

  static const Color purplePrimaryColor = Color(0xFFCDB5FF);
  static const Color purpleSecondaryColor = Color(0xFF8B62E0);

  static const Color blackPrimaryColor = Color(0xFF2B2233);
  static const Color blackSecondaryColor = Color(0xFF15101C);

  static const Color limePrimaryColor = Color(0xFFFDA65A);
  static const Color limeSecondaryColor = Color(0xFFD9661A);

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

  /// Warm cream behind every screen of the classic mode.
  static const Color backgroundColor = Color(0xFFFFF7ED);

  /// The one colour of primary actions, so it never reads as a team.
  static const Color ctaPrimaryColor = limePrimaryColor;
  static const Color ctaSecondaryColor = limeSecondaryColor;

  /// Light veil behind dialogs: keeps the page readable but out of focus.
  static const Color scrimColor = Color(0xB3FFF7ED);

  static const double clayBorderWidth = 3.0;
  static const BorderRadius clayRadius = BorderRadius.all(
    Radius.circular(24.0),
  );

  /// Soft "clay" surface: thin darker outline and a tinted drop shadow that
  /// tightens while the surface is pressed.
  static BoxDecoration clay(
    Color color,
    Color shade, {
    bool pressed = false,
    BorderRadius borderRadius = clayRadius,
  }) {
    return BoxDecoration(
      gradient: surfaceGradient(color),
      borderRadius: borderRadius,
      border: Border.all(color: shade, width: clayBorderWidth),
      boxShadow: [
        BoxShadow(
          color: shade.withValues(alpha: 0.38),
          blurRadius: pressed ? 4.0 : 14.0,
          offset: Offset(0.0, pressed ? 2.0 : 8.0),
        ),
      ],
    );
  }

  /// Light from the top and a hint of shade at the bottom, drawn
  /// over a clay surface to make it look puffy.
  static BoxDecoration clayGloss({BorderRadius borderRadius = clayRadius}) {
    return BoxDecoration(
      borderRadius: borderRadius,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.32),
          Colors.white.withValues(alpha: 0.0),
          Colors.black.withValues(alpha: 0.04),
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }

  static const double defaultIconSize = 48.0;

  static const Duration defaultDuration = Duration(milliseconds: 300);
  static const Curve defaultCurve = Curves.easeOutCirc;

  static const Duration entranceDuration = Duration(milliseconds: 450);
  static const Curve bounceCurve = Curves.easeOutBack;

  /// Blends [color] with white to get a brighter shade of the same hue.
  static Color lighten(Color color, [double amount = 0.2]) {
    return Color.lerp(color, Colors.white, amount)!;
  }

  /// Soft top-to-bottom gradient used on every coloured surface.
  static LinearGradient surfaceGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [lighten(color, 0.22), color],
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
