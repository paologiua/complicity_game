import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/models/floating_button_model.dart';
import 'package:flutter/material.dart';

import '../widgets/floating_buttons_section.dart';
import '../widgets/popup.dart';

class SecondStepScreen extends StatefulWidget {
  const SecondStepScreen({super.key});

  @override
  State<SecondStepScreen> createState() => _SecondStepScreenState();
}

class _SecondStepScreenState extends State<SecondStepScreen> {
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
                      color: ThemeConstants.greenPrimaryColor,
                      borderColor: ThemeConstants.greenSecondaryColor,
                      icon: Icons.psychology_alt_outlined,
                      text:
                          "Ad ogni turno il gioco sceglie una parola e un partecipante. Quest’ultimo, tramite degli indizi, dovrà far indovinare la praola alla propria squadra piuttosto che a quella avversaria.",
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingButtonsSection(
                    buttons: [
                      FloatingButtonModel(
                        icon: Icons.arrow_back_rounded,
                        action: () =>
                            Navigator.pop(context),
                      ),
                      FloatingButtonModel(
                        icon: Icons.arrow_forward_rounded,
                        action: () =>
                            Navigator.pushNamed(context, "/third_step"),
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
