import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:complicity_game/l10n/app_localizations.dart';

import '../constants/icons.dart';
import '../constants/theme.dart';
import '../models/player_model.dart';
import '../widgets/custom_floating_button.dart';
import '../widgets/pill_input.dart';
import '../widgets/screen_title.dart';
import '../widgets/team_switch.dart';

/// Sheet that adds a player to [initialTeam] or edits [initialValue].
class PlayerEditorSheet extends StatefulWidget {
  const PlayerEditorSheet({
    super.key,
    required this.onInsert,
    required this.onRemove,
    this.initialValue,
    this.initialTeam = Team.yellow,
  });

  final void Function(PlayerModel) onInsert;
  final void Function(PlayerModel) onRemove;
  final PlayerModel? initialValue;
  final Team initialTeam;

  @override
  State<PlayerEditorSheet> createState() => _PlayerEditorSheetState();
}

class _PlayerEditorSheetState extends State<PlayerEditorSheet> {
  late final TextEditingController _name;
  late Team _team;

  bool get _isEditing => widget.initialValue != null;

  @override
  void initState() {
    super.initState();
    _team = widget.initialValue?.team ?? widget.initialTeam;
    _name = TextEditingController(text: widget.initialValue?.name ?? '')
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _save() {
    String name = _name.text.trim();
    if (name.isEmpty) {
      return;
    }
    name = name[0].toUpperCase() + name.substring(1);

    Navigator.of(context).pop();
    widget.onInsert(
      PlayerModel(key: widget.initialValue?.key, name: name, team: _team),
    );
  }

  void _remove() {
    Navigator.of(context).pop();
    widget.onRemove(widget.initialValue!);
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 6.0, bottom: 6.0),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 14.0,
                color: ThemeConstants.mutedTextColor,
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScreenTitle(
            title: _isEditing ? l10n.editPlayerTitle : l10n.newPlayerTitle,
            padding: const EdgeInsets.only(top: 14.0, bottom: 16.0),
          ),
          _label(l10n.nameLabel),
          PillInput(
            controller: _name,
            color: _team.color,
            borderColor: _team.borderColor,
            icon: _team.icon,
            maxLength: 15,
            // In Safari on iPhone a field focused without a tap gets no
            // keyboard, but its hidden web input is left over the field, low
            // on the screen: the first tap then opens the keyboard on top of
            // it and Safari pushes the whole page up. There the field waits
            // for the tap, which places the input out of the way first.
            autofocus: !(kIsWeb && defaultTargetPlatform == TargetPlatform.iOS),
            hintText: l10n.playerNameHintText,
            onSubmit: (_) => _save(),
          ),
          const SizedBox(height: 16.0),
          _label(l10n.teamLabel),
          TeamSwitch(
            value: _team,
            onChange: (Team team) => setState(() {
              _team = team;
            }),
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              _isEditing
                  ? CustomFloatingButton(
                      onPressed: _remove,
                      icon: Icons.delete_outline_rounded,
                      text: l10n.deleteButtonLabel,
                      color: ThemeConstants.dangerColor,
                      size: 52.0,
                    )
                  : CustomFloatingButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: IconsConstants.close,
                      text: l10n.cancelButtonLabel,
                      size: 52.0,
                    ),
              const Spacer(),
              CustomFloatingButton(
                onPressed: _save,
                enabled: _name.text.trim().isNotEmpty,
                icon: Icons.check_rounded,
                text: l10n.saveButtonLabel,
                backgroundColor: ThemeConstants.ctaPrimaryColor,
                size: 52.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
