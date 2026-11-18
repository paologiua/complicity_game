import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/icons.dart';
import '../constants/theme.dart';
import '../models/player_model.dart';
import '../router.dart';
import '../services/game_service.dart';
import 'bouncy.dart';
import 'score_board.dart';

/// Top bar of the in-game screens: quit button and live score.
class GameHeader extends StatelessWidget {
  const GameHeader({super.key, this.highlight});

  /// The team that just scored, if any.
  final Team? highlight;

  /// How far the header reaches down from the top of the safe area. Content
  /// that scrolls under it starts this far down.
  static const double extent =
      ThemeConstants.defaultPadding + ScoreBoard.height;

  /// Heads home: the screens of a game in progress ask first, see
  /// [GameExit], so the X, the back button and the back gesture behave alike.
  void _confirmExit(BuildContext context) {
    context.go(Paths.home);
  }

  @override
  Widget build(BuildContext context) {
    final GameState state = context.read<GameService>().state;

    return Padding(
      padding: const EdgeInsets.only(top: ThemeConstants.defaultPadding),
      child: Hero(
        tag: "game_header",
        createRectTween: ThemeConstants.heroRectTween,
        child: Material(
          type: MaterialType.transparency,
          child: Row(
            children: [
              Bouncy(
                pressedScale: 0.88,
                child: GestureDetector(
                  onTap: () => _confirmExit(context),
                  child: Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: ThemeConstants.greyPrimaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ThemeConstants.greySecondaryColor,
                        width: ThemeConstants.clayBorderWidth,
                      ),
                    ),
                    child: const Icon(
                      IconsConstants.close,
                      color: ThemeConstants.defaultTextColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: ScoreBoard(
                  greenScore: state.getScore(Team.green),
                  yellowScore: state.getScore(Team.yellow),
                  targetScore: state.targetScore,
                  highlight: highlight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
