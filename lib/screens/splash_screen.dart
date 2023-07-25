import 'dart:async';

import 'package:complicity_game/constants/theme.dart';
import 'package:flutter/material.dart';
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
      () => Navigator.pushNamed(context, '/'),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: ThemeConstants.yellowPrimaryColor,
                        border: Border(
                          bottom: BorderSide(
                            color: ThemeConstants.yellowSecondaryColor,
                            width: ThemeConstants.defaultBorder,
                          ),
                          right: BorderSide(
                            color: ThemeConstants.yellowSecondaryColor,
                            width: ThemeConstants.defaultBorder,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: ThemeConstants.greenPrimaryColor,
                        border: Border(
                          bottom: BorderSide(
                            color: ThemeConstants.greenSecondaryColor,
                            width: ThemeConstants.defaultBorder,
                          ),
                          left: BorderSide(
                            color: ThemeConstants.greenSecondaryColor,
                            width: ThemeConstants.defaultBorder,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: ThemeConstants.bluePrimaryColor,
                        border: Border(
                          bottom: BorderSide(
                            color: ThemeConstants.blueSecondaryColor,
                            width: ThemeConstants.defaultBorder,
                          ),
                          right: BorderSide(
                            color: ThemeConstants.blueSecondaryColor,
                            width: ThemeConstants.defaultBorder,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: ThemeConstants.purplePrimaryColor,
                        border: Border(
                          bottom: BorderSide(
                            color: ThemeConstants.purpleSecondaryColor,
                            width: ThemeConstants.defaultBorder,
                          ),
                          left: BorderSide(
                            color: ThemeConstants.purpleSecondaryColor,
                            width: ThemeConstants.defaultBorder,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
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
          ),
        )
      ],
    );
  }
}
