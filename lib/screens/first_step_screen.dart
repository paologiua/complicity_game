import 'package:complicity_game/constants/icons.dart';
import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/models/floating_button_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/floating_buttons_section.dart';
import '../widgets/popup.dart';

class FirstStepScreen extends StatefulWidget {
  const FirstStepScreen({super.key});

  @override
  State<FirstStepScreen> createState() => _FirstStepScreenState();
}

class _FirstStepScreenState extends State<FirstStepScreen> {
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
                child: Popup(
                  heroTag: "popup",
                  color: ThemeConstants.greenPrimaryColor,
                  borderColor: ThemeConstants.greenSecondaryColor,
                  icon: IconsConstants.emojiObjects,
                  text: AppLocalizations.of(context)!.gameRulesPart1,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FloatingButtonsSection(
                  buttons: [
                    FloatingButtonModel(
                      key: "right_button",
                      icon: IconsConstants.arrowForward,
                      action: () => Navigator.pushNamed(
                        context,
                        "/game_rules/2",
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
