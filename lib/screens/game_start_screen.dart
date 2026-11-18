import 'package:complicity_game/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:complicity_game/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/player_model.dart';
import '../services/game_service.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/custom_floating_button.dart';
import '../widgets/game_header.dart';
import '../widgets/word_card.dart';
import 'package:complicity_game/router.dart';
import 'package:go_router/go_router.dart';

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
        CustomFloatingButton(
          heroTag: "right_button",
          icon: Icons.visibility_outlined,
          text: AppLocalizations.of(context)!.showWordButtonLabel,
          backgroundColor: ThemeConstants.ctaPrimaryColor,
          onPressed: goToNextPage,
        ),
      ],
      header: const GameHeader(),
      children: [
        Align(
          alignment: Alignment.center,
          child: _TurnCard(player: player),
        ),
      ],
    );
  }

  void goToNextPage() {
    GameExit.allow(() => context.pushReplacement(Paths.word));
  }
}

/// Says whose turn it is, with a badge in the colour of their team. Same size as the word
/// card it turns into on the next screen.
class _TurnCard extends StatelessWidget {
  const _TurnCard({required this.player});

  final PlayerModel player;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final TextStyle textStyle = Theme.of(context).textTheme.bodyLarge!;
    final Team team = player.team;

    return Hero(
      tag: "popup",
      createRectTween: ThemeConstants.heroRectTween,
      child: Container(
        width: double.infinity,
        height: WordCard.height,
        padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
        // White like every card that is only read: in this app a
        // coloured surface means it can be tapped. The team shows in the
        // badge.
        decoration: ThemeConstants.clay(
          ThemeConstants.greyPrimaryColor,
          ThemeConstants.greySecondaryColor,
        ),
        foregroundDecoration: ThemeConstants.clayGloss(),
        child: WordCard.unsqueezable(
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  // Flat, without outline or shadow: a label, not a button.
                  color: team.color.withValues(alpha: 0.55),
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      team.icon,
                      size: 18.0,
                      color: ThemeConstants.defaultTextColor,
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      team == Team.green
                          ? l10n.greenTeamText
                          : l10n.yellowTeamText,
                      style: textStyle.copyWith(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.turnOfText,
                      style: textStyle.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: ThemeConstants.mutedTextColor,
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        player.name.toUpperCase(),
                        maxLines: 1,
                        style: textStyle.copyWith(
                          fontSize: 38.0,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.disabled_visible_outlined,
                    size: 22.0,
                    color: ThemeConstants.defaultTextColor,
                  ),
                  const SizedBox(width: 8.0),
                  Flexible(
                    child: Text(
                      l10n.hideScreenHintText,
                      style: textStyle.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
