import 'package:complicity_game/constants/icons.dart';
import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/models/floating_button_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/floating_buttons_section.dart';
import '../widgets/pill.dart';

class ThirdStepScreen extends StatefulWidget {
  const ThirdStepScreen({super.key});

  @override
  State<ThirdStepScreen> createState() => _ThirdStepScreenState();
}

class _ThirdStepScreenState extends State<ThirdStepScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.blueSecondaryColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: ThemeConstants.bluePrimaryColor,
            border: Border.all(
              color: ThemeConstants.blueSecondaryColor,
              style: BorderStyle.solid,
              width: ThemeConstants.defaultBorder,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.defaultPadding,
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Pill(
                  heroTag: "popup",
                  color: ThemeConstants.yellowPrimaryColor,
                  borderColor: ThemeConstants.yellowSecondaryColor,
                  icon: IconsConstants.socialLeaderboard,
                  text: AppLocalizations.of(context)!.gameRulesPart3,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FloatingButtonsSection(
                  buttons: [
                    FloatingButtonModel(
                      key: "left_button",
                      icon: IconsConstants.arrowBack,
                      action: () => Navigator.pop(context),
                    ),
                    FloatingButtonModel(
                      key: "right_button",
                      icon: IconsConstants.arrowForward,
                      action: () => Navigator.pushNamed(
                        context,
                        '/team_selector',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
