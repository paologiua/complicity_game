import 'package:flutter/material.dart';

import '../constants/icons.dart';
import '../constants/theme.dart';

/// A themed guise of the game: same rules, different look and consequences.
enum GameMode { classic, drinking, dares, spicy }

class GameModeStyle {
  const GameModeStyle({
    required this.icon,
    required this.backgroundColor,
    required this.frameColor,
    required this.cardColor,
    required this.cardBorderColor,
    required this.symbols,
  });

  final IconData icon;

  /// Colour of the screen surface.
  final Color backgroundColor;

  /// Colour of the thick frame around the screen.
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
    backgroundColor: Color(0xFFCB9A66),
    frameColor: Color(0xFFB98451),
    cardColor: Color(0xFFF2D49B),
    cardBorderColor: Color(0xFFE6BF78),
    symbols: [
      Icons.local_bar_rounded,
      Icons.sports_bar_rounded,
      Icons.wine_bar_rounded,
      Icons.bubble_chart_outlined,
    ],
  );

  static const GameModeStyle _dares = GameModeStyle(
    icon: Icons.theater_comedy_rounded,
    backgroundColor: Color(0xFF8577AE),
    frameColor: Color(0xFF70629A),
    cardColor: Color(0xFFCFC2EA),
    cardBorderColor: Color(0xFFB9A8DE),
    symbols: [
      Icons.theater_comedy_rounded,
      Icons.casino_outlined,
      Icons.question_mark_rounded,
      Icons.mood_rounded,
    ],
  );

  static const GameModeStyle _spicy = GameModeStyle(
    icon: Icons.local_fire_department_rounded,
    backgroundColor: Color(0xFFC46A72),
    frameColor: Color(0xFFAE565F),
    cardColor: Color(0xFFF3B3AA),
    cardBorderColor: Color(0xFFE89A90),
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
