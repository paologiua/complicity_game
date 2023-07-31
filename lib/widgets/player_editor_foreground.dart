import 'package:complicity_game/constants/icons.dart';
import 'package:complicity_game/widgets/team_switch.dart';
import 'package:complicity_game/widgets/pill_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';

import '../constants/theme.dart';
import '../models/player_model.dart';
import 'custom_floating_button.dart';

class PlayerEditorForeground extends StatefulWidget {
  const PlayerEditorForeground({
    super.key,
    this.initialValue,
    this.onInsert,
    this.onRemove,
    this.onCancel,
  });

  final PlayerModel? initialValue;
  final void Function(PlayerModel)? onInsert;
  final void Function(PlayerModel)? onRemove;
  final void Function()? onCancel;

  @override
  State<PlayerEditorForeground> createState() => _PlayerEditorForegroundState();
}

class _PlayerEditorForegroundState extends State<PlayerEditorForeground> {
  late PlayerModel _player;
  late StreamSubscription<bool> keyboardSubscription;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod("TextInput.show");

    var keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible != _isKeyboardVisible) {
        if (!visible) {
          (widget.onCancel ?? () {})();
        }
        _isKeyboardVisible = visible;
      }
    });

    _player = widget.initialValue ??
        PlayerModel(
          key: null,
          name: "",
          team: (Team.values.toList()..shuffle()).first,
        );

    super.initState();
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Column(
            children: [
              CustomFloatingButton(
                onPressed: _player.key != null
                    ? () => (widget.onRemove ?? () {})(_player)
                    : widget.onCancel,
                icon: IconsConstants.close,
                text: _player.key != null
                    ? AppLocalizations.of(context)!.deleteButtonLabel
                    : AppLocalizations.of(context)!.cancelButtonLabel,
                size: 64.0,
              ),
              const SizedBox(height: ThemeConstants.defaultPadding),
              TeamSwitch(
                initialValue: _player.team,
                onChange: (Team team) => setState(() {
                  _player.team = team;
                }),
              ),
            ],
          ),
        ),
        PillInput(
          color: _player.team == Team.green
              ? ThemeConstants.greenPrimaryColor
              : ThemeConstants.yellowPrimaryColor,
          borderColor: _player.team == Team.green
              ? ThemeConstants.greenSecondaryColor
              : ThemeConstants.yellowSecondaryColor,
          initialValue: _player.name,
          maxLength: 15,
          autofocus: true,
          hintText: AppLocalizations.of(context)!.playerNameHintText,
          onChange: (String playerName) => setState(() {
            _player.name = playerName;
          }),
          onSubmit: (_) => (widget.onInsert ?? () {})(
            _player.copyWith(
              name: _player.name.trim(),
            ),
          ),
        ),
      ],
    );
  }
}
