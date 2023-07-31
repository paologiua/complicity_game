import 'package:complicity_game/constants/icons.dart';
import 'package:complicity_game/widgets/team_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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
                text: _player.key != null ? "Elimina" : "Annulla",
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
        AnimatedContainer(
          decoration: BoxDecoration(
            color: _player.team == Team.green
                ? ThemeConstants.greenPrimaryColor
                : ThemeConstants.yellowPrimaryColor,
            border: Border.all(
              color: _player.team == Team.green
                  ? ThemeConstants.greenSecondaryColor
                  : ThemeConstants.yellowSecondaryColor,
              width: ThemeConstants.defaultBorder,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(ThemeConstants.defaultBorder * 2),
            ),
          ),
          duration: ThemeConstants.defaultDuration,
          curve: ThemeConstants.defaultCurve,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.defaultPadding,
            vertical: ThemeConstants.defaultPadding / 2,
          ),
          child: TextFormField(
            initialValue: _player.name,
            maxLength: 15,
            cursorColor: ThemeConstants.defaultTextColor,
            autofocus: true,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: const InputDecoration(
              hintText: 'Nome del giocatore',
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              counterText: '',
              contentPadding: EdgeInsets.all(0.0),
            ),
            onChanged: (String playerName) => setState(() {
              _player.name = playerName;
            }),
            onFieldSubmitted: (_) => (widget.onInsert ?? () {})(
              _player.copyWith(
                name: _player.name.trim(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
