import 'package:complicity_game/constants/icons.dart';
import 'package:complicity_game/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:complicity_game/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/player_model.dart';
import '../services/game_service.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/custom_floating_button.dart';
import '../widgets/game_header.dart';
import '../widgets/pill.dart';

class GameStartScreen extends StatefulWidget {
  const GameStartScreen({super.key});

  @override
  State<GameStartScreen> createState() => _GameStartScreenState();
}

class _GameStartScreenState extends State<GameStartScreen> {
  late GameService _gameService;

  @override
  void initState() {
    _gameService = context.read<GameService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PlayerModel player = _gameService.state.getCurrentPlayer();

    return CustomScaffold(
      mode: _gameService.mode,
      floatingButtons: [
        const CustomFloatingButton(heroTag: "left_button", size: 0),
        CustomFloatingButton(
          heroTag: "right_button",
          icon: IconsConstants.arrowForward,
          onPressed: goToNextPage,
        ),
        const CustomFloatingButton(size: 0),
      ],
      children: [
        const Align(
          alignment: Alignment.topCenter,
          child: GameHeader(),
        ),
        Align(
          alignment: Alignment.center,
          child: Pill(
            heroTag: "popup",
            color: player.team.color,
            borderColor: player.team.borderColor,
            icon: Icons.disabled_visible_outlined,
            text: AppLocalizations.of(context)!.hideScreenText(
              player.name.toUpperCase(),
              player.team.name,
            ),
            onTap: goToNextPage,
          ),
        ),
      ],
    );
  }

  void goToNextPage() {
    Navigator.pushReplacementNamed(
      context,
      '/game/progress',
    );
  }
}
