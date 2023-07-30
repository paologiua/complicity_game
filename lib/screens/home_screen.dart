import 'package:complicity_game/widgets/pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/theme.dart';
import '../widgets/custom_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 140.0,
              width: double.infinity,
            ),
            Expanded(
              child: Center(
                child: Hero(
                  tag: "popup",
                  child: Container(
                    padding:
                        const EdgeInsets.all(ThemeConstants.defaultPadding),
                    decoration: const BoxDecoration(
                      color: ThemeConstants.blueDarkColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(ThemeConstants.defaultBorderRadius * 3),
                      ),
                    ),
                    child: Wrap(
                      runSpacing: ThemeConstants.defaultPadding,
                      children: [
                        Pill(
                          color: ThemeConstants.greenPrimaryColor,
                          borderColor: ThemeConstants.greenSecondaryColor,
                          icon: Icons.rule_rounded,
                          text: AppLocalizations.of(context)!
                              .gameRulesButtonLabel,
                          direction: Axis.horizontal,
                          onTap: () => Navigator.pushNamed(
                            context,
                            "/game_rules/1",
                          ),
                        ),
                        Pill(
                          color: ThemeConstants.yellowPrimaryColor,
                          borderColor: ThemeConstants.yellowSecondaryColor,
                          icon: Icons.sports_kabaddi_rounded,
                          text: AppLocalizations.of(context)!
                              .startGameButtonLabel,
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
            SizedBox(
              height: 140.0,
              width: double.infinity,
              child: Hero(
                tag: "logo",
                child: Container(
                  padding: const EdgeInsets.all(
                    ThemeConstants.defaultPadding,
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
      ],
    );
  }
}
