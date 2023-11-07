import 'package:complicity_game/constants/icons.dart';
import 'package:complicity_game/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/custom_scaffold.dart';
import '../widgets/custom_floating_button.dart';
import '../widgets/pill.dart';

class ThirdStepScreen extends StatefulWidget {
  const ThirdStepScreen({super.key});

  @override
  State<ThirdStepScreen> createState() => _ThirdStepScreenState();
}

class _ThirdStepScreenState extends State<ThirdStepScreen> {
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
          onPressed: goToNextPage,
        ),
      ],
      children: [
        Align(
          alignment: Alignment.center,
          child: Pill(
            heroTag: "popup",
            color: ThemeConstants.yellowPrimaryColor,
            borderColor: ThemeConstants.yellowSecondaryColor,
            icon: IconsConstants.socialLeaderboard,
            text: AppLocalizations.of(context)!.gameRulesPart3,
            onTap: goToNextPage,
          ),
        ),
      ],
    );
  }

  void goToNextPage() {
    Navigator.pushNamed(
      context,
      '/team_selector',
    );
  }
}
