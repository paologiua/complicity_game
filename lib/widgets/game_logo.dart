import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The wordmark, shared by the splash and the home so it flies between them.
class GameLogo extends StatelessWidget {
  const GameLogo({super.key});

  static const double maxWidth = 340.0;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "logo",
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: SvgPicture.asset(
          'assets/images/splash-icon.svg',
          width: double.infinity,
        ),
      ),
    );
  }
}
