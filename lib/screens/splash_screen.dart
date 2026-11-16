import 'dart:async';

import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/widgets/background_motion.dart';
import 'package:complicity_game/widgets/game_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      // A longer sweep than a normal page change: the game is opening.
      BackgroundMotion.sweep(1.0);
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.defaultPadding,
        ),
        child: Stack(
          children: [
            Center(
              child: const GameLogo()
                  .animate()
                  .fadeIn(duration: const Duration(milliseconds: 300))
                  .scaleXY(
                    begin: 0.5,
                    end: 1.0,
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.elasticOut,
                  )
                  .rotate(
                    begin: -0.03,
                    end: 0.0,
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.elasticOut,
                  ),
            ),
            const Align(
              alignment: Alignment(0.0, 0.72),
              child: _LoadingDots(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Three clay dots in the game colours, hopping one after the other.
class _LoadingDots extends StatelessWidget {
  const _LoadingDots();

  static const List<List<Color>> _colors = [
    [ThemeConstants.greenPrimaryColor, ThemeConstants.greenSecondaryColor],
    [ThemeConstants.yellowPrimaryColor, ThemeConstants.yellowSecondaryColor],
    [ThemeConstants.ctaPrimaryColor, ThemeConstants.ctaSecondaryColor],
  ];

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.of(context).disableAnimations;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < _colors.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.0),
            child: Container(
              width: 18.0,
              height: 18.0,
              decoration: ThemeConstants.clay(
                _colors[i][0],
                _colors[i][1],
                borderRadius: BorderRadius.circular(9.0),
              ),
            )
                .animate(
                  delay: Duration(milliseconds: 500 + i * 140),
                  onPlay: (controller) {
                    if (!reduceMotion) controller.repeat(reverse: true);
                  },
                )
                .moveY(
                  begin: 0.0,
                  end: -14.0,
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeOutQuad,
                ),
          ),
      ],
    );
  }
}
