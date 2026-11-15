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

  /// Darker shade, used for the status bar area and the dark shapes.
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
    backgroundColor: ThemeConstants.bluePrimaryColor,
    glowColor: Color(0xFF5C86FF),
    frameColor: ThemeConstants.blueSecondaryColor,
    cardColor: ThemeConstants.greenPrimaryColor,
    cardBorderColor: ThemeConstants.greenSecondaryColor,
    symbols: [
      Icons.question_mark_rounded,
      Icons.lock_outline_rounded,
      Icons.visibility_outlined,
      Icons.lightbulb_outline_rounded,
    ],
  );

  static const GameModeStyle _drinking = GameModeStyle(
    icon: Icons.local_bar_rounded,
    backgroundColor: Color(0xFFFF7A1A),
    glowColor: Color(0xFFFFA63D),
    frameColor: Color(0xFFD95700),
    cardColor: Color(0xFFFFE27A),
    cardBorderColor: Color(0xFFE0A21A),
    symbols: [
      Icons.local_bar_rounded,
      Icons.sports_bar_rounded,
      Icons.wine_bar_rounded,
      Icons.bubble_chart_outlined,
    ],
  );

  static const GameModeStyle _dares = GameModeStyle(
    icon: Icons.theater_comedy_rounded,
    backgroundColor: Color(0xFF8A3DF0),
    glowColor: Color(0xFFB067FF),
    frameColor: Color(0xFF6520C4),
    cardColor: Color(0xFFE0C4FF),
    cardBorderColor: Color(0xFFA772EC),
    symbols: [
      Icons.theater_comedy_rounded,
      Icons.casino_outlined,
      Icons.question_mark_rounded,
      Icons.mood_rounded,
    ],
  );

  static const GameModeStyle _spicy = GameModeStyle(
    icon: Icons.local_fire_department_rounded,
    backgroundColor: Color(0xFFF0305C),
    glowColor: Color(0xFFFF6A6A),
    frameColor: Color(0xFFC0143F),
    cardColor: Color(0xFFFFC2B5),
    cardBorderColor: Color(0xFFEC7F6C),
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

  /// Whether a stolen word or a draw makes the clue giver pick a dare.
  bool get hasDares => this == GameMode.dares || this == GameMode.spicy;
}
