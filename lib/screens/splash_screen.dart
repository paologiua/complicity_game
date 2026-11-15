import 'dart:async';

import 'package:complicity_game/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(context, '/'),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ColoredBox(
                      color: ThemeConstants.yellowPrimaryColor,
                      child: SizedBox.expand(),
                    ),
                  ),
                  Expanded(
                    child: ColoredBox(
                      color: ThemeConstants.greenPrimaryColor,
                      child: SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ColoredBox(
                      color: ThemeConstants.bluePrimaryColor,
                      child: SizedBox.expand(),
                    ),
                  ),
                  Expanded(
                    child: ColoredBox(
                      color: ThemeConstants.purplePrimaryColor,
                      child: SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Center(
          child: Hero(
            tag: "logo",
            child: Container(
              padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
              constraints: const BoxConstraints(
                maxWidth: ThemeConstants.defaultMaxWidth,
              ),
              child: SvgPicture.asset(
                'assets/images/splash-icon.svg',
                width: double.infinity,
              ),
            ),
          )
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 400))
              .scaleXY(
                begin: 0.6,
                end: 1.0,
                duration: const Duration(milliseconds: 900),
                curve: Curves.elasticOut,
              ),
        )
      ],
    );
  }
}
