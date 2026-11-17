import 'package:flutter/material.dart';

import '../constants/icons.dart';
import '../constants/theme.dart';

/// A themed guise of the game: same rules, different look and consequences.
enum GameMode { classic, drinking, dares, spicy }

class GameModeStyle {
  const GameModeStyle({
    required this.icon,
    required this.backgroundColor,
    required this.glowColor,
    required this.frameColor,
    required this.cardColor,
    required this.cardBorderColor,
    required this.symbols,
  });

  final IconData icon;

  /// Colour of the screen surface.
  final Color backgroundColor;

  /// Brighter shade that lights up the middle of the screen.
  final Color glowColor;

  /// Accent of the mode, used for the stronger background shapes.
  final Color frameColor;

  /// Colours of the cards that belong to this mode.
  final Color cardColor;
  final Color cardBorderColor;

  /// Icons scattered on the animated background.
  final List<IconData> symbols;
}

extension GameModeStyles on GameMode {
  static const GameModeStyle _classic = GameModeStyle(
    icon: IconsConstants.cognition,
    backgroundColor: ThemeConstants.backgroundColor,
    glowColor: Color(0xFFFFFDF8),
    frameColor: ThemeConstants.blueSecondaryColor,
    cardColor: ThemeConstants.bluePrimaryColor,
    cardBorderColor: ThemeConstants.blueSecondaryColor,
    symbols: [
      Icons.question_mark_rounded,
      Icons.lock_outline_rounded,
      Icons.visibility_outlined,
      Icons.lightbulb_outline_rounded,
    ],
  );

  static const GameModeStyle _drinking = GameModeStyle(
    icon: Icons.local_bar_rounded,
    backgroundColor: Color(0xFFFFF1CF),
    glowColor: Color(0xFFFFFAEC),
    frameColor: Color(0xFFE08A2A),
    cardColor: Color(0xFFFFC98A),
    cardBorderColor: Color(0xFFE08A2A),
    symbols: [
      Icons.local_bar_rounded,
      Icons.sports_bar_rounded,
      Icons.wine_bar_rounded,
      Icons.bubble_chart_outlined,
    ],
  );

  static const GameModeStyle _dares = GameModeStyle(
    icon: Icons.theater_comedy_rounded,
    backgroundColor: Color(0xFFF1E9FF),
    glowColor: Color(0xFFFBF8FF),
    frameColor: Color(0xFF8B62E0),
    cardColor: Color(0xFFCDB5FF),
    cardBorderColor: Color(0xFF8B62E0),
    symbols: [
      Icons.theater_comedy_rounded,
      Icons.casino_outlined,
      Icons.question_mark_rounded,
      Icons.mood_rounded,
    ],
  );

  static const GameModeStyle _spicy = GameModeStyle(
    icon: Icons.local_fire_department_rounded,
    backgroundColor: Color(0xFFFFE6EA),
    glowColor: Color(0xFFFFF7F8),
    frameColor: Color(0xFFDC4F69),
    cardColor: Color(0xFFFFA8B4),
    cardBorderColor: Color(0xFFDC4F69),
    symbols: [
      Icons.local_fire_department_rounded,
      Icons.favorite_border_rounded,
      Icons.question_mark_rounded,
      Icons.visibility_outlined,
    ],
  );

  GameModeStyle get style {
    switch (this) {
      case GameMode.classic:
        return _classic;
      case GameMode.drinking:
        return _drinking;
      case GameMode.dares:
        return _dares;
      case GameMode.spicy:
        return _spicy;
    }
  }

  /// Whether a stolen word or a draw makes the clue giver pick a dare. In the
  /// drinking mode the dares are drinking rules.
  bool get hasDares => this != GameMode.classic;

  /// Whether the losing team picks one last dare. The drinking mode ends with
  /// a sip per point of difference instead.
  bool get hasFinalDare => this == GameMode.dares || this == GameMode.spicy;
}
