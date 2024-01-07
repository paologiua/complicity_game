import 'dart:async';

import 'package:complicity_game/constants/options.dart';
import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/dialogs/player_selector_dialog.dart';
import 'package:complicity_game/widgets/custom_floating_button.dart';
import 'package:complicity_game/widgets/hidden_word_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../constants/icons.dart';
import '../models/player_model.dart';
import '../services/game_service.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/pill.dart';
import '../widgets/size_measurer.dart';

class GameProgressScreen extends StatefulWidget {
  const GameProgressScreen({super.key});

  @override
  State<GameProgressScreen> createState() => _GameProgressScreenState();
}

class _GameProgressScreenState extends State<GameProgressScreen> {
  late GameService _gameService;
  bool _hiddenWord = false;
  double _popupHeight = 0.0;

  late Timer _timer;

  @override
  void initState() {
    _gameService = context.read<GameService>();
    initTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
            decoration: const BoxDecoration(
              color: ThemeConstants.blueDarkColor,
              borderRadius: BorderRadius.all(
                Radius.circular(ThemeConstants.defaultBorderRadius * 3),
              ),
            ),
            child: Wrap(
              clipBehavior: Clip.hardEdge,
              runSpacing: ThemeConstants.defaultPadding,
              children: [
                Center(
                  child: CustomFloatingButton(
                    onPressed: draw,
                    icon: IconsConstants.close,
                    text: AppLocalizations.of(context)!.drawButtonLabel,
                    size: 64.0,
                  ),
                ),
                Stack(
                  children: [
                    _hiddenWord
                        ? HiddenWordPill(
                            greenTeamScore:
                                _gameService.state.getScore(Team.green),
                            yellowTeamScore:
                                _gameService.state.getScore(Team.yellow),
                            height: _popupHeight,
                            onTap: () => setState(() {
                              _hiddenWord = false;
                              initTimer();
                            }),
                          )
                        : SizeMeasurer(
                            onChange: (Size size) => setState(() {
                              _popupHeight = size.height;
                            }),
                            child: Pill(
                              heroTag: "popup",
                              color: ThemeConstants.greyPrimaryColor,
                              borderColor: ThemeConstants.greySecondaryColor,
                              icon: Icons.cookie_outlined,
                              text:
                                  AppLocalizations.of(context)!.mysteryWordText(
                                _gameService.state.getWord().toUpperCase(),
                              ),
                              onTap: () => setState(() {
                                _hiddenWord = true;
                                deleteTimer();
                              }),
                            ),
                          ),
                    IgnorePointer(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent,
                              width: ThemeConstants.defaultBorder,
                            ),
                          ),
                          padding: const EdgeInsets.all(
                            ThemeConstants.defaultPadding,
                          ),
                          child: _hiddenWord
                              ? const Icon(
                                  Icons.lock_open_rounded,
                                  size: ThemeConstants.defaultFontSize,
                                  color: ThemeConstants.greyPrimaryColor,
                                )
                              : Text(
                                  "${OptionsConstants.wordVisibilitySeconds - _timer.tick}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        height: 1,
                                      ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                Pill(
                  color: ThemeConstants.limePrimaryColor,
                  borderColor: ThemeConstants.limeSecondaryColor,
                  text: AppLocalizations.of(context)!.wordFoundButtonLabel,
                  onTap: () => showSelectorDialog(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void initTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {
        if (_timer.tick >= OptionsConstants.wordVisibilitySeconds) {
          _hiddenWord = true;
          deleteTimer();
        }
      }),
    );
  }

  void deleteTimer() {
    _timer.cancel();
  }

  void win(Team? team) {
    _gameService.state.win(team);

    Navigator.pushNamed(
      context,
      "/game/start",
    );
  }

  void draw() {
    win(null);
  }

  Future<void> showSelectorDialog() {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black12,
      barrierDismissible: false,
      builder: (BuildContext context) => PlayerSelectorDialog(
        players: _gameService.state.getSoothsayers(),
        onSelect: (PlayerModel player) => win(player.team),
      ),
    ).then((_) => setState(() {}));
  }
}
