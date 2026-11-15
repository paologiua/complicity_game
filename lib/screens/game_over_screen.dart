import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:complicity_game/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../models/game_mode.dart';
import '../models/player_model.dart';
import '../services/game_service.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/fireworks.dart';
import '../widgets/pill.dart';
import '../widgets/score_board.dart';

/// Celebrates the winning team and offers a rematch.
class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  late GameService _gameService;
  late GameState _state;
  late Team _winner;

  @override
  void initState() {
    _gameService = context.read<GameService>();
    _state = _gameService.state;
    _winner = _state.winner!;

    HapticFeedback.heavyImpact();
    super.initState();
  }

  void _playAgain() {
    _gameService.restart();
    Navigator.pushReplacementNamed(context, '/game/start');
  }

  void _goHome() {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  /// What the losing team has to do, or null in the classic mode.
  String? _consequence(AppLocalizations l10n) {
    final Team loser = _winner.opponent;

    switch (_gameService.mode) {
      case GameMode.classic:
        return null;
      case GameMode.drinking:
        return l10n.drinkFinalText(
          loser.name,
          l10n.sipsText(_state.scoreGap),
        );
      case GameMode.dares:
      case GameMode.spicy:
        final String? dare = _state.finalDare;

        return dare == null
            ? null
            : '${l10n.dareForTeamText(loser.name)}\n\n$dare';
    }
  }

  Widget _entrance(Widget child, int index) {
    return child
        .animate(delay: Duration(milliseconds: 400 + 150 * index))
        .fadeIn(duration: ThemeConstants.entranceDuration)
        .slideY(
          begin: 0.3,
          end: 0.0,
          duration: ThemeConstants.entranceDuration,
          curve: ThemeConstants.bounceCurve,
        );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final GameModeStyle style = _gameService.mode.style;
    final String? consequence = _consequence(l10n);

    return CustomScaffold(
      mode: _gameService.mode,
      children: [
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: ThemeConstants.defaultPadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Pill(
                  heroTag: "popup",
                  color: _winner.color,
                  borderColor: _winner.borderColor,
                  icon: Icons.emoji_events_rounded,
                  text: l10n.teamWinsText(_winner.name),
                ),
                const SizedBox(height: ThemeConstants.defaultPadding),
                _entrance(
                  ScoreBoard(
                    greenScore: _state.getScore(Team.green),
                    yellowScore: _state.getScore(Team.yellow),
                    targetScore: _state.targetScore,
                  ),
                  0,
                ),
                if (consequence != null) ...[
                  const SizedBox(height: ThemeConstants.defaultPadding),
                  _entrance(
                    Pill(
                      color: style.cardColor,
                      borderColor: style.cardBorderColor,
                      icon: style.icon,
                      text: consequence,
                    ),
                    1,
                  ),
                ],
                const SizedBox(height: ThemeConstants.defaultPadding),
                _entrance(
                  Pill(
                    direction: Axis.horizontal,
                    color: ThemeConstants.ctaPrimaryColor,
                    borderColor: ThemeConstants.ctaSecondaryColor,
                    icon: Icons.replay_rounded,
                    text: l10n.playAgainButtonLabel,
                    onTap: _playAgain,
                  ),
                  2,
                ),
                const SizedBox(height: ThemeConstants.defaultPadding),
                _entrance(
                  Pill(
                    direction: Axis.horizontal,
                    color: ThemeConstants.greyPrimaryColor,
                    borderColor: ThemeConstants.greySecondaryColor,
                    icon: Icons.home_rounded,
                    text: l10n.homeButtonLabel,
                    onTap: _goHome,
                  ),
                  3,
                ),
              ],
            ),
          ),
        ),
        // Drawn above the content so the bursts are not hidden by the cards.
        Positioned.fill(
          child: Fireworks(
            colors: [
              _winner.color,
              _winner.borderColor,
              style.cardBorderColor,
              ThemeConstants.ctaPrimaryColor,
            ],
          ),
        ),
      ],
    );
  }
}
