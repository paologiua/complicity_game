import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:complicity_game/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../constants/icons.dart';
import '../constants/theme.dart';
import '../dialogs/confirm_dialog.dart';
import '../models/player_model.dart';
import '../services/game_service.dart';
import 'bouncy.dart';
import 'score_board.dart';

/// Top bar of the in-game screens: quit button and live score.
class GameHeader extends StatelessWidget {
  const GameHeader({super.key, this.highlight});

  /// The team that just scored, if any.
  final Team? highlight;

  Future<void> _confirmExit(BuildContext context) async {
    HapticFeedback.lightImpact();

    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final NavigatorState navigator = Navigator.of(context);

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black12,
      barrierDismissible: false,
      builder: (BuildContext context) => ConfirmDialog(
        icon: Icons.logout_rounded,
        text: l10n.exitGameText,
        confirmLabel: l10n.exitButtonLabel,
        cancelLabel: l10n.cancelButtonLabel,
      ),
    );

    if (confirmed == true) {
      navigator.popUntil(ModalRoute.withName('/'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final GameState state = context.read<GameService>().state;

    return Padding(
      padding: const EdgeInsets.only(top: ThemeConstants.defaultPadding),
      child: Hero(
        tag: "game_header",
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
                    decoration: const BoxDecoration(
                      color: ThemeConstants.greyPrimaryColor,
                      shape: BoxShape.circle,
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
