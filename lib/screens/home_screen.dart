import 'package:complicity_game/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          child: Column(
            children: [
              const SizedBox(
                height: 140.0,
                width: double.infinity,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
                  child: Center(
                    child: Hero(
                      tag: "popup",
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: ThemeConstants.defaultMaxWidth,
                        ),
                        padding:
                            const EdgeInsets.all(ThemeConstants.defaultPadding),
                        decoration: BoxDecoration(
                          color:
                              ThemeConstants.defaultTextColor.withOpacity(0.3),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(ThemeConstants.defaultBorderRadius * 3),
                          ),
                        ),
                        child: Wrap(
                          runSpacing: ThemeConstants.defaultPadding,
                          children: [
                            Popup(
                              color: ThemeConstants.greenPrimaryColor,
                              borderColor: ThemeConstants.greenSecondaryColor,
                              icon: Icons.rule_rounded,
                              text: "Regolamento",
                              direction: Axis.horizontal,
                              onTap: () => Navigator.pushNamed(
                                context,
                                "/game_rules/1",
                              ),
                            ),
                            Popup(
                              color: ThemeConstants.yellowPrimaryColor,
                              borderColor: ThemeConstants.yellowSecondaryColor,
                              icon: Icons.sports_kabaddi_rounded,
                              text: "Inizia una partita",
                              direction: Axis.horizontal,
                              onTap: () => Navigator.pushNamed(
                                context,
                                "/team_selector",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 140.0,
                width: double.infinity,
                child: Hero(
                  tag: "logo",
                  child: Container(
                    padding:
                        const EdgeInsets.all(ThemeConstants.defaultPadding),
                    constraints: const BoxConstraints(
                      maxWidth: ThemeConstants.defaultMaxWidth,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/splash-icon.svg',
                      width: 200.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
