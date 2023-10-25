import 'package:complicity_game/screens/first_step_screen.dart';
import 'package:complicity_game/screens/home_screen.dart';
import 'package:complicity_game/screens/init_game_screen.dart';
import 'package:complicity_game/screens/second_step_screen.dart';
import 'package:complicity_game/screens/splash_screen.dart';
import 'package:complicity_game/screens/team_selector_screen.dart';
import 'package:complicity_game/screens/third_step_screen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const HomeScreen(),
  '/splash': (context) => const SplashScreen(),
  '/game_rules/1': (context) => const FirstStepScreen(),
  '/game_rules/2': (context) => const SecondStepScreen(),
  '/game_rules/3': (context) => const ThirdStepScreen(),
  '/team_selector': (context) => const TeamSelectorScreen(),
  '/game/init': (context) => const InitGameScreen(),
};