import 'package:complicity_game/constants/icons.dart';
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
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
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
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  direction: Axis.vertical,
                  spacing: ThemeConstants.defaultPadding,
                  children: [
                    SizedBox(
                      height: 64.0,
                      width: 160.0,
                      child: FloatingActionButton.extended(
                        heroTag: "rules_button",
                        backgroundColor: ThemeConstants.greyPrimaryColor,
                        icon: Icon(
                          IconsConstants.emojiObjects,
                          color: ThemeConstants.defaultTextStyle.color,
                          size: ThemeConstants.defaultIconSize,
                        ),
                        label: Text(
                          "Regole",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        elevation: 0,
                        highlightElevation: 0,
                        focusElevation: 0,
                        hoverElevation: 0,
                        onPressed: () =>
                            Navigator.pushNamed(context, "/game_rules/1"),
                      ),
                    ),
                    SizedBox(
                      height: 64.0,
                      width: 160.0,
                      child: FloatingActionButton.extended(
                        heroTag: "game_button",
                        backgroundColor: ThemeConstants.greyPrimaryColor,
                        icon: Icon(
                          IconsConstants.cognition,
                          color: ThemeConstants.defaultTextStyle.color,
                          size: ThemeConstants.defaultIconSize,
                        ),
                        label: Text(
                          "Gioca",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        elevation: 0,
                        highlightElevation: 0,
                        focusElevation: 0,
                        hoverElevation: 0,
                        onPressed: () =>
                            Navigator.pushNamed(context, "/team_selector"),
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
