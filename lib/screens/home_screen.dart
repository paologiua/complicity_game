import 'package:complicity_game/constants/icons.dart';
import 'package:complicity_game/widgets/pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:complicity_game/widgets/game_logo.dart';
import 'package:complicity_game/l10n/app_localizations.dart';

import '../constants/theme.dart';
import '../widgets/custom_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// The buttons rise into place after the logo has landed.
  Widget _entrance({required int delay, required Widget child}) {
    return child
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: const Duration(milliseconds: 250))
        .slideY(
          begin: 0.35,
          end: 0.0,
          duration: ThemeConstants.entranceDuration,
          curve: ThemeConstants.bounceCurve,
        );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      children: [
        Column(
          children: [
            Expanded(
              child: Center(
                child: const GameLogo()
                    // Starts from rest once the logo has landed from the
                    // splash, so the flight does not end with a jump.
                    .animate(
                      delay: const Duration(milliseconds: 700),
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .moveY(
                      begin: 0.0,
                      end: -10.0,
                      duration: const Duration(milliseconds: 2200),
                      curve: Curves.easeInOut,
                    )
                    .rotate(
                      begin: 0.0,
                      end: 0.01,
                      duration: const Duration(milliseconds: 2200),
                      curve: Curves.easeInOut,
                    ),
              ),
            ),
            _entrance(
              delay: 150,
              child: Pill(
                heroTag: "popup",
                color: ThemeConstants.ctaPrimaryColor,
                borderColor: ThemeConstants.ctaSecondaryColor,
                icon: IconsConstants.sportsKabaddi,
                text: AppLocalizations.of(context)!.startGameButtonLabel,
                onTap: () => Navigator.pushNamed(context, "/team_selector"),
              ),
            ),
            const SizedBox(height: 14.0),
            _entrance(
              delay: 260,
              child: Pill(
                color: ThemeConstants.greyPrimaryColor,
                borderColor: ThemeConstants.greySecondaryColor,
                icon: IconsConstants.rule,
                text: AppLocalizations.of(context)!.gameRulesButtonLabel,
                direction: Axis.horizontal,
                onTap: () => Navigator.pushNamed(context, "/game_rules"),
              ),
            ),
            const SizedBox(height: 36.0),
          ],
        ),
      ],
    );
  }
}
