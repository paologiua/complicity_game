import 'dart:ui';
import 'package:complicity_game/constants/icons.dart';
import 'package:complicity_game/widgets/team_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'dart:async';

import '../constants/theme.dart';
import '../models/player_model.dart';

class PlayerEditorForeground extends StatefulWidget {
  const PlayerEditorForeground({
    super.key,
    this.initialValue,
    this.onKeyboardChange,
    this.onKeyboardShow,
    this.onKeyboardHide,
    this.onSubmitted,
    this.onCancel,
  });

  final PlayerModel? initialValue;
  final void Function(bool)? onKeyboardChange;
  final void Function()? onKeyboardShow;
  final void Function()? onKeyboardHide;
  final void Function(PlayerModel)? onSubmitted;
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
        if (widget.onKeyboardChange != null) widget.onKeyboardChange!(visible);
        if (visible) {
          (widget.onKeyboardShow ?? () {})();
        } else {
          (widget.onKeyboardHide ?? () {})();
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
              Padding(
                padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
                child: SizedBox(
                  height: 64.0,
                  child: FloatingActionButton.extended(
                    onPressed: widget.onCancel,
                    backgroundColor: ThemeConstants.greyPrimaryColor,
                    elevation: 0,
                    highlightElevation: 0,
                    focusElevation: 0,
                    hoverElevation: 0,
                    icon: const Icon(
                      IconsConstants.close,
                      color: ThemeConstants.defaultTextColor,
                    ),
                    label: Text(
                      "Elimina",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
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
            onFieldSubmitted: widget.onSubmitted != null
                ? (_) => widget.onSubmitted!(
                      _player.copyWith(
                        name: _player.name.trim(),
                      ),
                    )
                : null,
          ),
        ),
      ],
    );
  }
}
