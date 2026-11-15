import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:complicity_game/l10n/app_localizations.dart';

import '../constants/icons.dart';
import '../constants/theme.dart';
import '../models/player_model.dart';
import '../widgets/custom_floating_button.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/screen_title.dart';

/// The three rules of the game on one page, in the order they matter.
class GameRulesScreen extends StatelessWidget {
  const GameRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool reduceMotion = MediaQuery.of(context).disableAnimations;

    final List<_Rule> rules = [
      _Rule(
        IconsConstants.emojiObjects,
        Team.yellow.color,
        Team.yellow.borderColor,
        l10n.gameRulesPart1,
      ),
      _Rule(
        IconsConstants.cognition,
        Team.green.color,
        Team.green.borderColor,
        l10n.gameRulesPart2,
      ),
      _Rule(
        IconsConstants.socialLeaderboard,
        ThemeConstants.bluePrimaryColor,
        ThemeConstants.blueSecondaryColor,
        l10n.gameRulesPart3,
      ),
    ];

    return CustomScaffold(
      floatingButtons: [
        CustomFloatingButton(
          heroTag: "left_button",
          icon: IconsConstants.arrowBack,
          onPressed: () => Navigator.pop(context),
        ),
        CustomFloatingButton(
          heroTag: "right_button",
          icon: Icons.play_arrow_rounded,
          text: l10n.startGameButtonLabel,
          backgroundColor: ThemeConstants.ctaPrimaryColor,
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/team_selector'),
        ),
      ],
      children: [
        ListView(
          padding: const EdgeInsets.only(bottom: 120.0),
          children: [
            ScreenTitle(title: l10n.gameRulesButtonLabel),
            for (int index = 0; index < rules.length; index++)
              reduceMotion
                  ? _RuleCard(number: index + 1, rule: rules[index])
                  : _RuleCard(number: index + 1, rule: rules[index])
                      .animate(delay: Duration(milliseconds: 50 * index))
                      .fadeIn(duration: ThemeConstants.entranceDuration)
                      .slideY(
                        begin: 0.15,
                        end: 0.0,
                        duration: ThemeConstants.entranceDuration,
                        curve: ThemeConstants.bounceCurve,
                      ),
          ],
        ),
      ],
    );
  }
}

class _Rule {
  const _Rule(this.icon, this.color, this.borderColor, this.text);

  final IconData icon;
  final Color color;
  final Color borderColor;
  final String text;
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({required this.number, required this.rule});

  final int number;
  final _Rule rule;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.bodyLarge!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: ThemeConstants.clay(
        ThemeConstants.greyPrimaryColor,
        ThemeConstants.greySecondaryColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52.0,
            height: 52.0,
            decoration: BoxDecoration(
              color: rule.color,
              shape: BoxShape.circle,
              border: Border.all(color: rule.borderColor, width: 2.5),
            ),
            child: Icon(
              rule.icon,
              size: 28.0,
              color: ThemeConstants.defaultTextColor,
            ),
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$number',
                  style: textStyle.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: ThemeConstants.mutedTextColor,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  rule.text,
                  style: textStyle.copyWith(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
