import 'package:complicity_game/screens/game_rules_screen.dart';
import 'package:complicity_game/screens/game_over_screen.dart';
import 'package:complicity_game/screens/game_progress_screen.dart';
import 'package:complicity_game/screens/game_result_screen.dart';
import 'package:complicity_game/screens/game_setup_screen.dart';
import 'package:complicity_game/screens/home_screen.dart';
import 'package:complicity_game/screens/game_start_screen.dart';
import 'package:complicity_game/screens/splash_screen.dart';
import 'package:complicity_game/screens/team_selector_screen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const HomeScreen(),
  '/splash': (context) => const SplashScreen(),
  '/game_rules': (context) => const GameRulesScreen(),
  '/team_selector': (context) => const TeamSelectorScreen(),
  '/game/setup': (context) => const GameSetupScreen(),
  '/game/start': (context) => const GameStartScreen(),
  '/game/progress': (context) => const GameProgressScreen(),
  '/game/result': (context) => const GameResultScreen(),
  '/game/over': (context) => const GameOverScreen(),
};