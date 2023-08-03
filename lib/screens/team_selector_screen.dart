import 'package:complicity_game/constants/icons.dart';
import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/services/player_manager_service.dart';
import 'package:complicity_game/widgets/custom_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/player_model.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/player_editor_foreground.dart';
import '../widgets/pill.dart';

class TeamSelectorScreen extends StatefulWidget {
  const TeamSelectorScreen({super.key});

  @override
  State<TeamSelectorScreen> createState() => _TeamSelectorScreenState();
}

class _TeamSelectorScreenState extends State<TeamSelectorScreen> {
  late PlayerManagerService _playerManagerService;

  Future<void> showEditorDialog({PlayerModel? player}) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => PlayerEditorForeground(
        initialValue: player,
        onInsert: _playerManagerService.insertPlayer,
        onRemove: _playerManagerService.removePlayer,
      ),
    ).then((_) => setState(() {}));
  }

  @override
  void initState() {
    _playerManagerService = context.read<PlayerManagerService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      floatingButtons: [
        CustomFloatingButton(
          heroTag: "left_button",
          icon: IconsConstants.add,
          onPressed: showEditorDialog,
        ),
        CustomFloatingButton(
          heroTag: "right_button",
          icon: IconsConstants.arrowForward,
          onPressed: () => Navigator.pushNamed(context, '/'),
        ),
      ],
      children: [
        Padding(
          padding: const EdgeInsets.only(top: ThemeConstants.defaultPadding),
          child: ListView(
            children: [
              const SizedBox(height: 212.0),
              ..._playerManagerService
                  .getPlayers()
                  .map(
                    (PlayerModel player) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Pill(
                        direction: Axis.horizontal,
                        text: player.name,
                        color: player.team == Team.green
                            ? ThemeConstants.greenPrimaryColor
                            : ThemeConstants.yellowPrimaryColor,
                        borderColor: player.team == Team.green
                            ? ThemeConstants.greenSecondaryColor
                            : ThemeConstants.yellowSecondaryColor,
                        onTap: () => showEditorDialog(player: player),
                      ),
                    ),
                  )
                  .toList(),
              const SizedBox(height: 96.0),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: ThemeConstants.defaultPadding,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ThemeConstants.bluePrimaryColor,
                  ThemeConstants.bluePrimaryColor.withOpacity(0.0),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.0, 1.0),
                stops: const [0.8, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Pill(
              heroTag: "popup",
              color: ThemeConstants.greyPrimaryColor,
              borderColor: ThemeConstants.greySecondaryColor,
              icon: IconsConstants.groupAdd,
              text: AppLocalizations.of(context)!.enterParticipantsNamesText,
            ),
          ),
        ),
      ],
    );
  }
}
