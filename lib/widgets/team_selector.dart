import 'package:complicity_game/constants/icons.dart';
import 'package:complicity_game/constants/theme.dart';
import 'package:flutter/material.dart';

import '../models/player_model.dart';

class TeamSelector extends StatefulWidget {
  const TeamSelector({
    super.key,
    required this.initialValue,
    required this.onChange,
  });

  final Team initialValue;
  final void Function(Team team) onChange;

  @override
  State<TeamSelector> createState() => _TeamSelectorState();
}

class _TeamSelectorState extends State<TeamSelector> {
  late Team _team;

  void onChange(Team team) {
    if (_team != team) {
      setState(() {
        _team = team;
      });
      widget.onChange(team);
    }
  }

  @override
  void initState() {
    _team = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ThemeConstants.greySecondaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(ThemeConstants.defaultBorder * 2),
        ),
      ),
      padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChange(Team.yellow),
              child: AnimatedContainer(
                padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
                decoration: BoxDecoration(
                  color: _team == Team.yellow
                      ? ThemeConstants.yellowPrimaryColor
                      : ThemeConstants.greyPrimaryColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(ThemeConstants.defaultBorder),
                  ),
                ),
                duration: ThemeConstants.defaultDuration,
                curve: ThemeConstants.defaultCurve,
                child: Column(
                  children: <Widget>[
                    const Icon(
                      IconsConstants.emojiObjects,
                      size: ThemeConstants.defaultIconSize,
                      color: ThemeConstants.defaultTextColor,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      "Squadra gialla",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: ThemeConstants.defaultPadding,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChange(Team.green),
              child: AnimatedContainer(
                padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
                decoration: BoxDecoration(
                  color: _team == Team.green
                      ? ThemeConstants.greenPrimaryColor
                      : ThemeConstants.greyPrimaryColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(ThemeConstants.defaultBorder),
                  ),
                ),
                duration: ThemeConstants.defaultDuration,
                curve: ThemeConstants.defaultCurve,
                child: Column(
                  children: <Widget>[
                    const Icon(
                      IconsConstants.cognition,
                      size: ThemeConstants.defaultIconSize,
                      color: ThemeConstants.defaultTextColor,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      "Squadra verde",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
