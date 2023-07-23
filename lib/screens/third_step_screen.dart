import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/models/floating_button_model.dart';
import 'package:flutter/material.dart';

import '../widgets/floating_buttons_section.dart';
import '../widgets/popup.dart';

class ThirdStepScreen extends StatefulWidget {
  const ThirdStepScreen({super.key});

  @override
  State<ThirdStepScreen> createState() => _ThirdStepScreenState();
}

class _ThirdStepScreenState extends State<ThirdStepScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.defaultPadding),
            child: Stack(
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: "popup",
                    child: Popup(
                      color: ThemeConstants.yellowPrimaryColor,
                      borderColor: ThemeConstants.yellowSecondaryColor,
                      icon: Icons.workspace_premium_outlined,
                      text: "Vince la squadra che indovina più parole.",
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingButtonsSection(
                    buttons: [
                      FloatingButtonModel(
                        icon: Icons.arrow_back_rounded,
                        action: () => Navigator.pop(context),
                      ),
                      FloatingButtonModel(
                        icon: Icons.arrow_forward_rounded,
                        action: () =>
                            Navigator.pushNamed(context, '/team_selector'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
