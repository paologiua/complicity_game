import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/models/floating_button_model.dart';
import 'package:flutter/material.dart';

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
              const Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: "popup",
                  child: Popup(
                    color: ThemeConstants.greenPrimaryColor,
                    borderColor: ThemeConstants.greenSecondaryColor,
                    icon: Icons.emoji_objects_outlined,
                    text:
                        "Complicity Game è un gioco di gruppo. Occorre dividere i partecipanti in due squadre composte da persone con un grande senso di complicità reciproco.",
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FloatingButtonsSection(
                  buttons: [
                    FloatingButtonModel(
                      key: "right_button",
                      icon: Icons.arrow_forward_rounded,
                      action: () =>
                          Navigator.pushNamed(context, "/game_rules/2"),
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
