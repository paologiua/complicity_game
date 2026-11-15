import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:complicity_game/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../constants/icons.dart';
import '../constants/options.dart';
import '../constants/theme.dart';
import '../models/game_mode.dart';
import '../services/game_service.dart';
import '../widgets/bouncy.dart';
import '../widgets/custom_floating_button.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/screen_title.dart';

/// Lets the players pick the game mode and how many words win the game.
class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  late GameService _gameService;

  late GameMode _mode;
  late int _targetScore;

  @override
  void initState() {
    _gameService = context.read<GameService>();
    _mode = _gameService.mode;
    _targetScore = _gameService.targetScore;
    super.initState();
  }


  void _selectMode(GameMode mode) {
    if (_mode != mode) {
      HapticFeedback.selectionClick();
      setState(() {
        _mode = mode;
      });
    }
  }

  void _selectTargetScore(int targetScore) {
    HapticFeedback.selectionClick();
    setState(() {
      _targetScore = targetScore;
    });
  }

  void _startGame() {
    _gameService.configure(mode: _mode, targetScore: _targetScore);
    _gameService.start();

    Navigator.pushNamed(context, '/game/start');
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return CustomScaffold(
      mode: _mode,
      floatingButtons: [
        CustomFloatingButton(
          heroTag: "left_button",
          icon: IconsConstants.arrowBack,
          onPressed: () => Navigator.pop(context),
        ),
        CustomFloatingButton(
          heroTag: "right_button",
          icon: Icons.play_arrow_rounded,
          text: l10n.playButtonLabel,
          backgroundColor: ThemeConstants.ctaPrimaryColor,
          onPressed: _startGame,
        ),
      ],
      children: [
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: ThemeConstants.defaultPadding,
              bottom: 110.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScreenTitle(
                  title: l10n.chooseModeText,
                  padding: const EdgeInsets.only(bottom: 20.0),
                ),
                for (int row = 0; row < 2; row++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        for (int column = 0; column < 2; column++) ...[
                          if (column > 0) const SizedBox(width: 12.0),
                          Expanded(
                            child: _ModeCard(
                              mode: GameMode.values[row * 2 + column],
                              selected:
                                  GameMode.values[row * 2 + column] == _mode,
                              onTap: () => _selectMode(
                                GameMode.values[row * 2 + column],
                              ),
                            )
                                .animate(
                                  delay: Duration(
                                    milliseconds: 70 * (row * 2 + column),
                                  ),
                                )
                                .fadeIn(
                                  duration: ThemeConstants.entranceDuration,
                                )
                                .scaleXY(
                                  begin: 0.8,
                                  end: 1.0,
                                  duration: ThemeConstants.entranceDuration,
                                  curve: ThemeConstants.bounceCurve,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                SizedBox(
                  height: 52.0,
                  child: AnimatedSwitcher(
                    duration: ThemeConstants.defaultDuration,
                    child: Text(
                      l10n.modeDescription(_mode.name),
                      key: ValueKey<GameMode>(_mode),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: ThemeConstants.defaultPadding),
                _TargetScoreSelector(
                  label: l10n.wordsToWinText,
                  value: _targetScore,
                  onChange: _selectTargetScore,
                )
                    .animate(delay: const Duration(milliseconds: 120))
                    .fadeIn(duration: ThemeConstants.entranceDuration)
                    .slideY(
                      begin: 0.2,
                      end: 0.0,
                      duration: ThemeConstants.entranceDuration,
                      curve: ThemeConstants.bounceCurve,
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final GameMode mode;
  final bool selected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final GameModeStyle style = mode.style;
    final TextStyle textStyle = Theme.of(context).textTheme.bodyLarge!;

    Widget icon = Icon(
      style.icon,
      size: 48.0,
      color: ThemeConstants.defaultTextColor,
    );

    // The icon of the card in focus keeps swinging to draw the eye.
    if (selected && !MediaQuery.of(context).disableAnimations) {
      icon = icon
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .rotate(
            begin: -0.03,
            end: 0.03,
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOut,
          );
    }

    return AnimatedScale(
      scale: selected ? 1.0 : 0.94,
      duration: ThemeConstants.entranceDuration,
      curve: ThemeConstants.bounceCurve,
      child: Bouncy(
        pressedScale: 0.95,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: ThemeConstants.defaultDuration,
            curve: ThemeConstants.defaultCurve,
            height: 132.0,
            decoration: ThemeConstants.clay(
              style.cardColor,
              // The chosen card gets a dark outline; the others their own.
              selected
                  ? ThemeConstants.blackPrimaryColor
                  : style.cardBorderColor,
            ),
            foregroundDecoration: ThemeConstants.clayGloss(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(height: 8.0),
                Text(
                  l10n.modeName(mode.name).toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle.copyWith(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TargetScoreSelector extends StatelessWidget {
  const _TargetScoreSelector({
    required this.label,
    required this.value,
    required this.onChange,
  });

  final String label;
  final int value;
  final void Function(int) onChange;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.bodyLarge!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: ThemeConstants.clay(
        ThemeConstants.greyPrimaryColor,
        ThemeConstants.greySecondaryColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              for (int option in OptionsConstants.targetScores)
                Expanded(
                  child: Bouncy(
                    pressedScale: 0.9,
                    child: GestureDetector(
                      onTap: () => onChange(option),
                      child: AnimatedContainer(
                        duration: ThemeConstants.defaultDuration,
                        curve: ThemeConstants.defaultCurve,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        decoration: BoxDecoration(
                          color: option == value
                              ? ThemeConstants.blackPrimaryColor
                              : ThemeConstants.backgroundColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              ThemeConstants.defaultBorderRadius,
                            ),
                          ),
                        ),
                        child: Text(
                          '$option',
                          textAlign: TextAlign.center,
                          style: textStyle.copyWith(
                            color: option == value
                                ? ThemeConstants.greyPrimaryColor
                                : ThemeConstants.defaultTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
