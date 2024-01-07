import 'dart:ui';

import 'package:complicity_game/constants/icons.dart';
import 'package:complicity_game/widgets/pill.dart';
import 'package:complicity_game/widgets/size_measurer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/theme.dart';
import '../models/player_model.dart';
import '../widgets/custom_floating_button.dart';

class PlayerSelectorDialog extends StatefulWidget {
  const PlayerSelectorDialog({
    super.key,
    required this.players,
    required this.onSelect,
  });

  final List<PlayerModel> players;
  final void Function(PlayerModel) onSelect;

  @override
  State<PlayerSelectorDialog> createState() => _PlayerSelectorDialogState();
}

class _PlayerSelectorDialogState extends State<PlayerSelectorDialog> {
  double _popupHeight = 0.0;

  void _close() {
    Navigator.of(context).pop();
  }

  void _onSelect(PlayerModel player) {
    _close();
    widget.onSelect(player);
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
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: _popupHeight - 2 * ThemeConstants.defaultBorder >=
                                0
                            ? _popupHeight - 2 * ThemeConstants.defaultBorder
                            : 0,
                      ),
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 2 *
                                (ThemeConstants.defaultBorder +
                                    ThemeConstants.defaultPadding),
                          ),
                          ...widget.players
                              .map(
                                (PlayerModel player) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Pill(
                                    direction: Axis.horizontal,
                                    text: player.name,
                                    color: player.team == Team.green
                                        ? ThemeConstants.greenPrimaryColor
                                        : ThemeConstants.yellowPrimaryColor,
                                    borderColor: player.team == Team.green
                                        ? ThemeConstants.greenSecondaryColor
                                        : ThemeConstants.yellowSecondaryColor,
                                    onTap: () => _onSelect(player),
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: ThemeConstants.defaultPadding,
                        ),
                        child: SizeMeasurer(
                          onChange: (Size size) => setState(() {
                            _popupHeight = size.height;
                            print(_popupHeight);
                          }),
                          child: Wrap(
                            runSpacing: ThemeConstants.defaultPadding,
                            children: [
                              Center(
                                child: CustomFloatingButton(
                                  onPressed: _close,
                                  icon: IconsConstants.close,
                                  text: AppLocalizations.of(context)!
                                      .cancelButtonLabel,
                                  size: 64.0,
                                ),
                              ),
                              const Pill(
                                heroTag: "popup",
                                color: ThemeConstants.greyPrimaryColor,
                                borderColor: ThemeConstants.greySecondaryColor,
                                icon: IconsConstants.groupAdd,
                                text: "Parola indovinata da",
                              ),
                            ],
                          ),
                        ),
                      ),
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
