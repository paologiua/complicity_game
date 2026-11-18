import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:complicity_game/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../constants/icons.dart';
import '../constants/theme.dart';
import '../models/game_mode.dart';
import '../models/player_model.dart';
import '../services/game_service.dart';
import '../widgets/custom_floating_button.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/game_header.dart';
import '../widgets/pill.dart';
import 'package:complicity_game/router.dart';
import 'package:go_router/go_router.dart';

/// Shows who scored in the turn that just ended and what it costs the
/// clue giver in the themed modes.
class GameResultScreen extends StatefulWidget {
  const GameResultScreen({super.key});

  @override
  State<GameResultScreen> createState() => _GameResultScreenState();
}

class _GameResultScreenState extends State<GameResultScreen> {
  late GameService _gameService;
  late RoundOutcome _outcome;

  @override
  void initState() {
    _gameService = context.read<GameService>();
    _outcome = _gameService.state.lastOutcome!;

    if (_outcome.isDraw) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.heavyImpact();
    }
    super.initState();
  }

  void goToNextPage() {
    if (_gameService.state.isOver) {
      GameExit.allow(() => context.pushReplacement(Paths.over));
      return;
    }

    _gameService.state.nextTurn();
    GameExit.allow(() => context.pushReplacement(Paths.turn));
  }

  String _headline(AppLocalizations l10n) {
    final Team? team = _outcome.scoringTeam;

    if (team == null) {
      return l10n.roundDrawText;
    }

    return _outcome.isStolen
        ? l10n.roundStolenText(team.name)
        : l10n.roundPointText(team.name);
  }

  IconData get _icon {
    if (_outcome.isDraw) {
      return Icons.sentiment_neutral_rounded;
    }

    return _outcome.isStolen ? Icons.bolt_rounded : Icons.celebration_rounded;
  }

  /// The text of the penalty card, or null when the turn has no penalty.
  String? _consequence(AppLocalizations l10n) {
    if (!_outcome.hasPenalty) {
      return null;
    }

    final PlayerModel cluePlayer = _outcome.cluePlayer;

    switch (_gameService.mode) {
      case GameMode.classic:
        return null;
      case GameMode.drinking:
        final String? rule = _outcome.dare;

        // Without a list of drinking rules, the plain sip of the first
        // versions of the game.
        if (rule == null) {
          return _outcome.isDraw
              ? l10n.drinkPlayerText(cluePlayer.name)
              : l10n.drinkTeamText(cluePlayer.team.name);
        }

        return '${l10n.dareForPlayerText(cluePlayer.name)}\n\n$rule';
      case GameMode.dares:
      case GameMode.spicy:
        final String? dare = _outcome.dare;

        return dare == null
            ? null
            : '${l10n.dareForPlayerText(cluePlayer.name)}\n\n$dare';
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final GameModeStyle style = _gameService.mode.style;
    final Team? team = _outcome.scoringTeam;
    final String? consequence = _consequence(l10n);

    return CustomScaffold(
      mode: _gameService.mode,
      floatingButtons: [
        CustomFloatingButton(
          heroTag: "right_button",
          icon: IconsConstants.arrowForward,
          text: l10n.nextButtonLabel,
          backgroundColor: ThemeConstants.ctaPrimaryColor,
          onPressed: goToNextPage,
        ),
      ],
      children: [
        Column(
          children: [
            GameHeader(highlight: team),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    top: ThemeConstants.defaultPadding,
                    bottom: 110.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Pill(
                        heroTag: "popup",
                        color: team?.color ?? ThemeConstants.greyPrimaryColor,
                        borderColor: team?.borderColor ??
                            ThemeConstants.greySecondaryColor,
                        icon: _icon,
                        text: '${_headline(l10n)}\n\n'
                            '${l10n.theWordWasText(_outcome.word.toUpperCase())}',
                      ),
                      if (consequence != null) ...[
                        const SizedBox(height: ThemeConstants.defaultPadding),
                        Pill(
                          color: style.cardColor,
                          borderColor: style.cardBorderColor,
                          icon: style.icon,
                          text: consequence,
                        )
                            .animate(delay: const Duration(milliseconds: 500))
                            .fadeIn(duration: ThemeConstants.entranceDuration)
                            .slideY(
                              begin: 0.3,
                              end: 0.0,
                              duration: ThemeConstants.entranceDuration,
                              curve: ThemeConstants.bounceCurve,
                            )
                            .then()
                            .shake(
                              hz: 4,
                              rotation: 0.02,
                              duration: const Duration(milliseconds: 400),
                            ),
                      ],
                    ],
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
