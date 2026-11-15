import 'package:complicity_game/constants/icons.dart';
import 'package:complicity_game/widgets/pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:complicity_game/l10n/app_localizations.dart';

import '../constants/theme.dart';
import '../widgets/custom_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      children: [
        Column(
          children: [
            Expanded(
              child: Center(
                child: Hero(
                  tag: "logo",
                  child: Padding(
                    padding: const EdgeInsets.all(
                      ThemeConstants.defaultPadding,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/splash-icon.svg',
                      width: 220.0,
                    ),
                  ),
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scaleXY(
                      begin: 1.0,
                      end: 1.05,
                      duration: const Duration(milliseconds: 1600),
                      curve: Curves.easeInOut,
                    ),
              ),
            ),
            Pill(
              heroTag: "popup",
              color: ThemeConstants.ctaPrimaryColor,
              borderColor: ThemeConstants.ctaSecondaryColor,
              icon: IconsConstants.sportsKabaddi,
              text: AppLocalizations.of(context)!.startGameButtonLabel,
              onTap: () => Navigator.pushNamed(context, "/team_selector"),
            ),
            const SizedBox(height: 14.0),
            Pill(
              color: ThemeConstants.greyPrimaryColor,
              borderColor: ThemeConstants.greySecondaryColor,
              icon: IconsConstants.rule,
              text: AppLocalizations.of(context)!.gameRulesButtonLabel,
              direction: Axis.horizontal,
              onTap: () => Navigator.pushNamed(context, "/game_rules/1"),
            ),
            const SizedBox(height: 36.0),
          ],
        ),
      ],
    );
  }
}
