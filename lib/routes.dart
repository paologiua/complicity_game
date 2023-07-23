import 'package:complicity_game/screens/first_step_screen.dart';
import 'package:complicity_game/screens/second_step_screen.dart';
import 'package:complicity_game/screens/team_selector_screen.dart';
import 'package:complicity_game/screens/third_step_screen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const FirstStepScreen(),
  '/first_step': (context) => const FirstStepScreen(),
  '/second_step': (context) => const SecondStepScreen(),
  '/third_step': (context) => const ThirdStepScreen(),
  '/team_selector': (context) => const TeamSelectorScreen(),
};