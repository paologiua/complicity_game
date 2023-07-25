import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/models/floating_button_model.dart';
import 'package:complicity_game/services/player_manager_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/player_model.dart';
import '../widgets/floating_buttons_section.dart';
import '../widgets/list_item.dart';
import '../widgets/player_editor_foreground.dart';
import '../widgets/popup.dart';

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
    return Scaffold(
      backgroundColor: ThemeConstants.blueSecondaryColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: ThemeConstants.bluePrimaryColor,
            border: Border.all(
              color: ThemeConstants.blueSecondaryColor,
              style: BorderStyle.solid,
              width: ThemeConstants.defaultBorder,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.defaultPadding,
          ),
          child: Stack(
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
              const Align(
                alignment: Alignment.topCenter,
                child: Hero(
                  tag: "popup",
                  child: Popup(
                    color: ThemeConstants.greyPrimaryColor,
                    borderColor: ThemeConstants.greySecondaryColor,
                    icon: Icons.group_add_outlined,
                    text: "Inserisci i nomi dei partecipanti.",
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FloatingButtonsSection(
                  buttons: [
                    FloatingButtonModel(
                      key: "left_button",
                      icon: Icons.add_rounded,
                      action: () => openPlayerEditor(null),
                    ),
                    FloatingButtonModel(
                      key: "right_button",
                      icon: Icons.arrow_forward_rounded,
                      action: () => Navigator.pushNamed(context, '/first_step'),
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
        ),
      ),
    );
  }
}
