import 'dart:ui';

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
import '../widgets/custom_floating_button.dart';

class PlayerEditorDialog extends StatefulWidget {
  const PlayerEditorDialog({
    super.key,
    required this.onInsert,
    required this.onRemove,
    this.initialValue,
  });

  final void Function(PlayerModel) onInsert;
  final void Function(PlayerModel) onRemove;
  final PlayerModel? initialValue;

  @override
  State<PlayerEditorDialog> createState() => _PlayerEditorDialogState();
}

class _PlayerEditorDialogState extends State<PlayerEditorDialog> {
  late PlayerModel _player;
  late StreamSubscription<bool> _keyboardSubscription;
  bool _isKeyboardVisible = false;

  void _close() {
    _keyboardSubscription.cancel();
    Navigator.of(context).pop();
  }

  void _onInsert() {
    _close();

    String name = _player.name.trim();
    if (name.isNotEmpty) {
      name = name[0].toUpperCase() + name.substring(1);
    }

    widget.onInsert(_player.copyWith(name: name));
  }

  void _onRemove() {
    _close();

    widget.onRemove(_player);
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod("TextInput.show");

    _keyboardSubscription = KeyboardVisibilityController().onChange.listen(
      (bool visible) {
        if (visible != _isKeyboardVisible) {
          if (!visible) {
            _close();
          }
          _isKeyboardVisible = visible;
        }
      },
    );

    _player = widget.initialValue ??
        PlayerModel(
          key: null,
          name: "",
          team: (Team.values.toList()..shuffle()).first,
        );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _close,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 100.0,
          sigmaY: 100.0,
        ),
        child: Dialog(
          insetPadding: const EdgeInsets.all(0.0),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          child: GestureDetector(
            onTap: () {},
            child: Center(
              child: Container(
              constraints: const BoxConstraints(
                maxWidth: ThemeConstants.defaultMaxWidth,
              ),
                margin: const EdgeInsets.all(ThemeConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: [
                          _player.key != null
                              ? CustomFloatingButton(
                                  onPressed: _onRemove,
                                  icon: IconsConstants.close,
                                  text: AppLocalizations.of(context)!
                                      .deleteButtonLabel,
                                  size: 64.0,
                                )
                              : CustomFloatingButton(
                                  onPressed: _close,
                                  icon: IconsConstants.close,
                                  text: AppLocalizations.of(context)!
                                      .cancelButtonLabel,
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
                      onSubmit: (_) => _onInsert(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
