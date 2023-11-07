import 'package:complicity_game/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../constants/icons.dart';
import '../models/player_model.dart';
import '../services/game_service.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/pill.dart';

class GameProgressScreen extends StatefulWidget {
  const GameProgressScreen({super.key});

  @override
  State<GameProgressScreen> createState() => _GameProgressScreenState();
}

class _GameProgressScreenState extends State<GameProgressScreen> {
  late GameService _gameService;

  @override
  void initState() {
    _gameService = context.read<GameService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      children: [
        Align(
          alignment: Alignment.center,
          child: Hero(
            tag: "popup",
            child: Container(
              padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
              decoration: const BoxDecoration(
                color: ThemeConstants.blueDarkColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(ThemeConstants.defaultBorderRadius * 3),
                ),
              ),
              child: Wrap(
                clipBehavior: Clip.hardEdge,
                runSpacing: ThemeConstants.defaultPadding,
                children: [
                  Pill(
                    color: ThemeConstants.greenPrimaryColor,
                    borderColor: ThemeConstants.greenSecondaryColor,
                    icon: IconsConstants.cognition,
                    text: AppLocalizations.of(context)!.makeTeamWinButtonLabel(
                      Team.green.name,
                    ),
                    direction: Axis.horizontal,
                    onTap: () => win(Team.green),
                  ),
                  Pill(
                    color: ThemeConstants.greyPrimaryColor,
                    borderColor: ThemeConstants.greySecondaryColor,
                    icon: Icons.cookie_outlined,
                    text: AppLocalizations.of(context)!.mysteryWordText(
                      _gameService.state.getWord().toUpperCase(),
                    ),
                  ),
                  Pill(
                    color: ThemeConstants.yellowPrimaryColor,
                    borderColor: ThemeConstants.yellowSecondaryColor,
                    icon: IconsConstants.emojiObjects,
                    text: AppLocalizations.of(context)!.makeTeamWinButtonLabel(
                      Team.yellow.name,
                    ),
                    direction: Axis.horizontal,
                    onTap: () => win(Team.yellow),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void win(Team team) {
    _gameService.state.win(team);
    
    Navigator.pushNamed(
      context,
      "/game/start",
    );
  }
}
