import 'package:complicity_game/constants/icons.dart';
import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/models/floating_button_model.dart';
import 'package:complicity_game/services/player_manager_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/player_model.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/floating_buttons_section.dart';
import '../widgets/list_item.dart';
import '../widgets/player_editor_foreground.dart';
import '../widgets/pill.dart';

class TeamSelectorScreen extends StatefulWidget {
  const TeamSelectorScreen({super.key});

  @override
  State<TeamSelectorScreen> createState() => _TeamSelectorScreenState();
}

class _TeamSelectorScreenState extends State<TeamSelectorScreen> {
  bool playerEditorClosed = true;
  PlayerModel? _playerInEdit;
  late PlayerManagerService playerManagerService;

  void addPlayer(PlayerModel player) {
    if (playerManagerService.insertPlayer(player) != null) {
      setState(() {});
    }
  }

  void openPlayerEditor(PlayerModel? playerInEdit) {
    _playerInEdit = playerInEdit;
    setState(() {
      playerEditorClosed = false;
    });
  }

  void closePlayerEditor() {
    _playerInEdit = null;
    setState(() {
      playerEditorClosed = true;
    });
  }

  @override
  void initState() {
    playerManagerService = context.read<PlayerManagerService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: ThemeConstants.defaultPadding),
            child: ListView(
              children: [
                const SizedBox(height: 212.0),
                ...playerManagerService
                    .getPlayers()
                    .map(
                      (PlayerModel player) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ListItem(
                          text: player.name,
                          color: player.team == Team.green
                              ? ThemeConstants.greenPrimaryColor
                              : ThemeConstants.yellowPrimaryColor,
                          borderColor: player.team == Team.green
                              ? ThemeConstants.greenSecondaryColor
                              : ThemeConstants.yellowSecondaryColor,
                          onTap: () => openPlayerEditor(player),
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
              constraints: const BoxConstraints(
                maxWidth: ThemeConstants.defaultMaxWidth,
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
                text: AppLocalizations.of(context)!
                    .enterParticipantsNamesText,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingButtonsSection(
              buttons: [
                FloatingButtonModel(
                  key: "left_button",
                  icon: IconsConstants.add,
                  action: () => openPlayerEditor(null),
                ),
                FloatingButtonModel(
                  key: "right_button",
                  icon: IconsConstants.arrowForward,
                  action: () => Navigator.pushNamed(context, '/'),
                ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: ThemeConstants.defaultDuration,
            switchInCurve: ThemeConstants.defaultCurve,
            switchOutCurve: ThemeConstants.defaultCurve,
            transitionBuilder:
                (Widget child, Animation<double> animation) =>
                    FadeTransition(opacity: animation, child: child),
            child: !playerEditorClosed
                ? PlayerEditorForeground(
                    initialValue: _playerInEdit,
                    onKeyboardHide: closePlayerEditor,
                    onSubmitted: (PlayerModel player) => addPlayer(player),
                    onCancel: closePlayerEditor,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
