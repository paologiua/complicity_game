import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/theme.dart';

/// The wordmark, shared by the splash and the home so it flies between them.
class GameLogo extends StatelessWidget {
  const GameLogo({super.key});

  static const double maxWidth = 340.0;

  /// Width over height of the artwork. Reserving the space up front matters:
  /// the picture loads a moment after the first frame, and a logo with no
  /// height yet gives the flight between screens nowhere to land.
  static const double _aspectRatio = 367.52 / 148.03;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "logo",
      createRectTween: ThemeConstants.heroRectTween,
      // Fly the logo that is already on screen, not the one of the screen
      // being opened, which may not have loaded its picture yet.
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        return (fromHeroContext.widget as Hero).child;
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: AspectRatio(
          aspectRatio: _aspectRatio,
          child: SvgPicture.asset(
            'assets/images/splash-icon.svg',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
