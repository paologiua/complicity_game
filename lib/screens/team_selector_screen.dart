import 'package:complicity_game/constants/icons.dart';
import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/services/player_manager_service.dart';
import 'package:complicity_game/widgets/custom_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:complicity_game/l10n/app_localizations.dart';

import '../models/player_model.dart';
import '../sheets/clay_sheet.dart';
import '../sheets/player_editor_sheet.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/name_chip.dart';
import '../widgets/screen_title.dart';

/// Lists the players of each team and lets them be added, edited or moved.
class TeamSelectorScreen extends StatefulWidget {
  const TeamSelectorScreen({super.key});

  @override
  State<TeamSelectorScreen> createState() => _TeamSelectorScreenState();
}

class _TeamSelectorScreenState extends State<TeamSelectorScreen> {
  late PlayerManagerService _playerManagerService;

  @override
  void initState() {
    _playerManagerService = context.read<PlayerManagerService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return CustomScaffold(
      floatingButtons: [
        CustomFloatingButton(
          heroTag: "left_button",
          icon: IconsConstants.arrowBack,
          onPressed: () => Navigator.pop(context),
        ),
        CustomFloatingButton(
          heroTag: "right_button",
          icon: IconsConstants.arrowForward,
          text: l10n.nextButtonLabel,
          backgroundColor: ThemeConstants.ctaPrimaryColor,
          enabled: _playerManagerService.isReadyToPlay(),
          onPressed: () => Navigator.pushNamed(context, '/game/setup'),
        ),
      ],
      children: [
        ListView(
          padding: const EdgeInsets.only(bottom: 120.0),
          children: [
            ScreenTitle(
              title: l10n.playersTitle,
              subtitle: l10n.enterParticipantsNamesText,
            ),
            for (final Team team in const [Team.yellow, Team.green])
              _TeamPanel(
                team: team,
                players: _playerManagerService.getPlayersByTeam(team),
                onAdd: () => _showEditor(team: team),
                onEdit: (PlayerModel player) => _showEditor(player: player),
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _showEditor({PlayerModel? player, Team team = Team.yellow}) {
    return showClaySheet<void>(
      context: context,
      builder: (BuildContext context) => PlayerEditorSheet(
        initialValue: player,
        initialTeam: team,
        onInsert: _playerManagerService.insertPlayer,
        onRemove: _playerManagerService.removePlayer,
      ),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }
}

class _TeamPanel extends StatelessWidget {
  const _TeamPanel({
    required this.team,
    required this.players,
    required this.onAdd,
    required this.onEdit,
  });

  final Team team;
  final List<PlayerModel> players;
  final void Function() onAdd;
  final void Function(PlayerModel) onEdit;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final TextStyle textStyle = Theme.of(context).textTheme.bodyLarge!;
    final bool reduceMotion = MediaQuery.of(context).disableAnimations;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: ThemeConstants.clay(
        ThemeConstants.greyPrimaryColor,
        ThemeConstants.greySecondaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: team.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: team.borderColor, width: 2.5),
                ),
                child: Icon(
                  team.icon,
                  size: 24.0,
                  color: ThemeConstants.defaultTextColor,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  team == Team.green ? l10n.greenTeamText : l10n.yellowTeamText,
                  style: textStyle.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                '${players.length}',
                style: textStyle.copyWith(
                  color: ThemeConstants.mutedTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14.0),
          if (players.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                l10n.emptyTeamText,
                style: textStyle.copyWith(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: ThemeConstants.mutedTextColor,
                ),
              ),
            ),
          Wrap(
            spacing: 8.0,
            runSpacing: 10.0,
            children: [
              for (final PlayerModel player in players)
                reduceMotion
                    ? NameChip(
                        key: ValueKey<dynamic>(player.key),
                        label: player.name,
                        color: team.color,
                        borderColor: team.borderColor,
                        onTap: () => onEdit(player),
                      )
                    : NameChip(
                        label: player.name,
                        color: team.color,
                        borderColor: team.borderColor,
                        onTap: () => onEdit(player),
                      )
                        .animate(key: ValueKey<dynamic>(player.key))
                        .fadeIn(duration: ThemeConstants.defaultDuration)
                        .scaleXY(
                          begin: 0.6,
                          end: 1.0,
                          duration: ThemeConstants.entranceDuration,
                          curve: ThemeConstants.bounceCurve,
                        ),
              NameChip(
                label: l10n.addPlayerButtonLabel,
                icon: IconsConstants.add,
                color: ThemeConstants.backgroundColor,
                borderColor: ThemeConstants.greySecondaryColor,
                onTap: onAdd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
