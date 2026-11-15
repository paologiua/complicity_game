import 'package:complicity_game/constants/icons.dart';
import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/services/player_manager_service.dart';
import 'package:complicity_game/widgets/custom_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:complicity_game/l10n/app_localizations.dart';

import '../models/player_model.dart';
import '../widgets/custom_scaffold.dart';
import '../dialogs/player_editor_dialog.dart';
import '../widgets/pill.dart';
import '../widgets/size_measurer.dart';

class TeamSelectorScreen extends StatefulWidget {
  const TeamSelectorScreen({super.key});

  @override
  State<TeamSelectorScreen> createState() => _TeamSelectorScreenState();
}

class _TeamSelectorScreenState extends State<TeamSelectorScreen> {
  late PlayerManagerService _playerManagerService;
  double _popupHeight = 0.0;

  @override
  void initState() {
    _playerManagerService = context.read<PlayerManagerService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isReadyToPlay = _playerManagerService.isReadyToPlay();

    return CustomScaffold(
      floatingButtons: [
        if (!isReadyToPlay) const CustomFloatingButton(size: 0),
        CustomFloatingButton(
          heroTag: "left_button",
          icon: IconsConstants.add,
          onPressed: showEditorDialog,
        ),
        isReadyToPlay
            ? CustomFloatingButton(
                heroTag: "right_button",
                icon: IconsConstants.arrowForward,
                onPressed: () =>
                    Navigator.pushNamed(context, '/game/setup'),
              )
            : const CustomFloatingButton(heroTag: "right_button", size: 0),
      ],
      children: [
        Padding(
          padding: const EdgeInsets.only(top: ThemeConstants.defaultPadding),
          child: ListView(
            children: [
              SizedBox(height: _popupHeight + ThemeConstants.defaultPadding),
              ..._playerManagerService
                  .getPlayers()
                  .map(
                    (PlayerModel player) => Padding(
                      key: ValueKey<dynamic>(player.key),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Pill(
                        direction: Axis.horizontal,
                        text: player.name,
                        color: player.team.color,
                        borderColor: player.team.borderColor,
                        onTap: () => showEditorDialog(player: player),
                      )
                          .animate()
                          .fadeIn(duration: ThemeConstants.entranceDuration)
                          .slideX(
                            begin: player.team == Team.green ? 0.15 : -0.15,
                            end: 0.0,
                            duration: ThemeConstants.entranceDuration,
                            curve: ThemeConstants.bounceCurve,
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
                  ThemeConstants.bluePrimaryColor.withValues(alpha: 0.0),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.0, 1.0),
                stops: const [0.8, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: SizeMeasurer(
              onChange: (Size size) => setState(() {
                _popupHeight = size.height;
              }),
              child: Pill(
                heroTag: "popup",
                color: ThemeConstants.greyPrimaryColor,
                borderColor: ThemeConstants.greySecondaryColor,
                icon: IconsConstants.groupAdd,
                text: AppLocalizations.of(context)!.enterParticipantsNamesText,
                onTap: showEditorDialog,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> showEditorDialog({PlayerModel? player}) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black12,
      barrierDismissible: false,
      builder: (BuildContext context) => PlayerEditorDialog(
        initialValue: player,
        onInsert: _playerManagerService.insertPlayer,
        onRemove: _playerManagerService.removePlayer,
      ),
    ).then((_) => setState(() {}));
  }
}
