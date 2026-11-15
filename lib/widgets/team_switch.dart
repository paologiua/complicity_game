import 'package:complicity_game/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:complicity_game/l10n/app_localizations.dart';

import '../models/player_model.dart';

/// Two-way switch between the teams: a coloured thumb slides under the
/// chosen one.
class TeamSwitch extends StatelessWidget {
  const TeamSwitch({
    super.key,
    required this.value,
    required this.onChange,
  });

  final Team value;
  final void Function(Team team) onChange;

  static const List<Team> _order = [Team.yellow, Team.green];

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final bool reduceMotion = MediaQuery.of(context).disableAnimations;

    return Container(
      height: 76.0,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: ThemeConstants.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        border: Border.all(
          color: ThemeConstants.greySecondaryColor,
          width: 2.0,
        ),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: value == Team.yellow
                ? Alignment.centerLeft
                : Alignment.centerRight,
            duration: reduceMotion
                ? Duration.zero
                : ThemeConstants.entranceDuration,
            curve: ThemeConstants.bounceCurve,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1.0,
              child: AnimatedContainer(
                duration: ThemeConstants.defaultDuration,
                decoration: BoxDecoration(
                  gradient: ThemeConstants.surfaceGradient(value.color),
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  border: Border.all(color: value.borderColor, width: 2.5),
                ),
              ),
            ),
          ),
          Row(
            children: [
              for (final Team team in _order)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: team == value,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (team != value) {
                          HapticFeedback.selectionClick();
                          onChange(team);
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            scale: team == value ? 1.15 : 1.0,
                            duration: ThemeConstants.entranceDuration,
                            curve: ThemeConstants.bounceCurve,
                            child: Icon(
                              team.icon,
                              size: 24.0,
                              color: ThemeConstants.defaultTextColor,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            team == Team.green
                                ? l10n.greenTeamText
                                : l10n.yellowTeamText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
