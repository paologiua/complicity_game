import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/services/game_service.dart';
import 'package:complicity_game/services/player_manager_service.dart';
import 'package:complicity_game/widgets/background_motion.dart';
import 'package:complicity_game/widgets/game_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:complicity_game/router.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _openHome();
  }

  /// Leaves the splash once it has been on screen long enough and the saved
  /// players, the words and the dares are all loaded, so no screen after it
  /// ever shows up half empty. On a slow connection the splash simply waits.
  Future<void> _openHome() async {
    final Future<void> players = context.read<PlayerManagerService>().restore();
    final Future<void> words = context.read<GameService>().ready;

    await Future.wait<void>([
      Future<void>.delayed(const Duration(milliseconds: 2400)),
      // Both already cope with missing data: a failure only means the game
      // goes on without it, so it must not keep the splash up.
      players.catchError((Object _) {}),
      words.catchError((Object _) {}),
    ]);

    if (!mounted) return;
    // A longer sweep than a normal page change: the game is opening.
    BackgroundMotion.sweep(1.0);
    AppStart.done = true;
    context.go(Paths.home);
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
