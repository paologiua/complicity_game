import 'package:complicity_game/constants/icons.dart';
import 'package:complicity_game/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/custom_scaffold.dart';
import '../widgets/custom_floating_button.dart';
import '../widgets/pill.dart';

class SecondStepScreen extends StatefulWidget {
  const SecondStepScreen({super.key});

  @override
  State<SecondStepScreen> createState() => _SecondStepScreenState();
}

class _SecondStepScreenState extends State<SecondStepScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      floatingButtons: [
        CustomFloatingButton(
          heroTag: "left_button",
          icon: IconsConstants.arrowBack,
          onPressed: () => Navigator.pop(context),
        ),
        CustomFloatingButton(
          heroTag: "right_button",
          icon: IconsConstants.arrowForward,
          onPressed: () => Navigator.pushNamed(
            context,
            "/game_rules/3",
          ),
        ),
      ],
      children: [
        Align(
          alignment: Alignment.center,
          child: Pill(
            heroTag: "popup",
            color: ThemeConstants.greenPrimaryColor,
            borderColor: ThemeConstants.greenSecondaryColor,
            icon: IconsConstants.cognition,
            text: AppLocalizations.of(context)!.gameRulesPart2,
          ),
        ),
      ],
    );
  }
}
