import 'package:complicity_game/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
          child: Pill(
            heroTag: "popup",
            color: ThemeConstants.greyPrimaryColor,
            borderColor: ThemeConstants.greySecondaryColor,
            icon: Icons.cookie_outlined,
            text: AppLocalizations.of(context)!.mysteryWordText(
              _gameService.state.getWord().toUpperCase(),
            ),
          ),
        ),
      ],
    );
  }
}
