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
                        height: 300.0,
                        padding:
                            const EdgeInsets.all(ThemeConstants.defaultPadding),
                        decoration: const BoxDecoration(
                          color: Color(0xFF606971),
                          borderRadius: BorderRadius.all(
                            Radius.circular(60.0),
                          ),
                        ),
                        child: Wrap(
                          runSpacing: ThemeConstants.defaultPadding,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                context,
                                "/game_rules/1",
                              ),
                              child: Container(
                                height: 120.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: ThemeConstants.greenPrimaryColor,
                                  border: Border.all(
                                    width: ThemeConstants.defaultBorder,
                                    color: ThemeConstants.greenSecondaryColor,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(40.0),
                                  ),
                                ),
                                child: Center(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    direction: Axis.vertical,
                                    runSpacing: ThemeConstants.defaultPadding,
                                    children: [
                                      Icon(
                                        Icons.rule_rounded,
                                        color: ThemeConstants
                                            .defaultTextStyle.color,
                                        size: 48.0,
                                      ),
                                      Center(
                                        child: Text(
                                          "Regolamento",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                context,
                                "/team_selector",
                              ),
                              child: Container(
                                height: 120.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: ThemeConstants.yellowPrimaryColor,
                                  border: Border.all(
                                    width: ThemeConstants.defaultBorder,
                                    color: ThemeConstants.yellowSecondaryColor,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(40.0),
                                  ),
                                ),
                                child: Center(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    direction: Axis.vertical,
                                    runSpacing: ThemeConstants.defaultPadding,
                                    children: [
                                      Icon(
                                        Icons.sports_kabaddi_rounded,
                                        color: ThemeConstants
                                            .defaultTextStyle.color,
                                        size: 48.0,
                                      ),
                                      Center(
                                        child: Text(
                                          "Inizia una partita",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
