import 'package:flutter/material.dart';
import 'package:complicity_game/l10n/app_localizations.dart';

import '../constants/icons.dart';
import '../constants/theme.dart';
import '../models/player_model.dart';
import '../widgets/custom_floating_button.dart';
import '../widgets/name_chip.dart';
import '../widgets/screen_title.dart';

/// Sheet that asks which of [players] guessed the word.
class PlayerSelectorSheet extends StatelessWidget {
  const PlayerSelectorSheet({
    super.key,
    required this.players,
    required this.onSelect,
  });

  final List<PlayerModel> players;
  final void Function(PlayerModel) onSelect;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScreenTitle(
            title: l10n.guessedByText,
            padding: const EdgeInsets.only(top: 14.0, bottom: 20.0),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10.0,
            runSpacing: 10.0,
            children: [
              for (final PlayerModel player in players)
                NameChip(
                  label: player.name,
                  icon: player.team.icon,
                  color: player.team.color,
                  borderColor: player.team.borderColor,
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelect(player);
                  },
                ),
            ],
          ),
          const SizedBox(height: 24.0),
          CustomFloatingButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: IconsConstants.close,
            text: l10n.cancelButtonLabel,
            size: 52.0,
          ),
        ],
      ),
    );
  }
}
