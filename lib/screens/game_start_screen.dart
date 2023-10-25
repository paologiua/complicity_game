import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/models/player_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../services/game_service.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/custom_floating_button.dart';
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
    return CustomScaffold(
      floatingButtons: [
        const CustomFloatingButton(heroTag: "left_button", size: 0),
        CustomFloatingButton(
          heroTag: "right_button",
          icon: Icons.casino_outlined,
          onPressed: () => Navigator.pushNamed(
            context,
            '/game/progress',
          ),
        ),
        const CustomFloatingButton(size: 0),
      ],
      children: [
        Align(
          alignment: Alignment.center,
          child: Pill(
            heroTag: "popup",
            color: _gameService.state.getCurrentPlayer().team == Team.green
                ? ThemeConstants.greenPrimaryColor
                : ThemeConstants.yellowPrimaryColor,
            borderColor: _gameService.state.getCurrentPlayer().team == Team.green
                ? ThemeConstants.greenSecondaryColor
                : ThemeConstants.yellowSecondaryColor,
            icon: Icons.disabled_visible_outlined,
            text: AppLocalizations.of(context)!.hideScreenText(
              _gameService.state.getCurrentPlayer().name.toUpperCase(),
              _gameService.state.getCurrentPlayer().team.name, 
            ),
          ),
        ),
      ],
    );
  }
}
