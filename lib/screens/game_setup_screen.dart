import 'package:flutter/gestures.dart';
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
import '../widgets/pill.dart';

/// Lets the players pick the game mode and how many words win the game.
class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  late GameService _gameService;
  late PageController _pageController;

  late GameMode _mode;
  late int _targetScore;

  @override
  void initState() {
    _gameService = context.read<GameService>();
    _mode = _gameService.mode;
    _targetScore = _gameService.targetScore;
    _pageController = PageController(
      viewportFraction: 0.78,
      initialPage: _mode.index,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
          icon: IconsConstants.arrowForward,
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
                Pill(
                  heroTag: "popup",
                  direction: Axis.horizontal,
                  color: ThemeConstants.greyPrimaryColor,
                  borderColor: ThemeConstants.greySecondaryColor,
                  icon: Icons.tune_rounded,
                  text: l10n.chooseModeText,
                ),
                const SizedBox(height: ThemeConstants.defaultPadding),
                SizedBox(
                  height: 300.0,
                  child: PageView.builder(
                    controller: _pageController,
                    // Lets the carousel be dragged with a mouse too, which
                    // desktop and web do not allow by default.
                    scrollBehavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: PointerDeviceKind.values.toSet(),
                    ),
                    clipBehavior: Clip.none,
                    itemCount: GameMode.values.length,
                    onPageChanged: (int index) =>
                        _selectMode(GameMode.values[index]),
                    itemBuilder: (BuildContext context, int index) {
                      final GameMode mode = GameMode.values[index];

                      return _ModeCard(
                        mode: mode,
                        selected: mode == _mode,
                        onTap: () => _pageController.animateToPage(
                          index,
                          duration: ThemeConstants.entranceDuration,
                          curve: ThemeConstants.bounceCurve,
                        ),
                      );
                    },
                  ),
                )
                    .animate()
                    .fadeIn(duration: ThemeConstants.entranceDuration)
                    .slideY(
                      begin: 0.12,
                      end: 0.0,
                      duration: ThemeConstants.entranceDuration,
                      curve: ThemeConstants.bounceCurve,
                    ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (GameMode mode in GameMode.values)
                      AnimatedContainer(
                        duration: ThemeConstants.defaultDuration,
                        curve: ThemeConstants.defaultCurve,
                        width: mode == _mode ? 24.0 : 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          color: mode == _mode
                              ? ThemeConstants.greyPrimaryColor
                              : Colors.white.withValues(alpha: 0.35),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                  ],
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
      size: 64.0,
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
      scale: selected ? 1.0 : 0.88,
      duration: ThemeConstants.entranceDuration,
      curve: ThemeConstants.bounceCurve,
      child: AnimatedOpacity(
        opacity: selected ? 1.0 : 0.7,
        duration: ThemeConstants.defaultDuration,
        child: Bouncy(
          pressedScale: 0.96,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: ThemeConstants.surfaceGradient(style.cardColor),
                border: Border.all(
                  color: style.cardBorderColor,
                  width: 14.0,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(ThemeConstants.defaultBorderRadius * 2),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(height: 12.0),
                  Text(
                    l10n.modeName(mode.name).toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle.copyWith(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Flexible(
                    child: Text(
                      l10n.modeDescription(mode.name),
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
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
      padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
      decoration: const BoxDecoration(
        color: ThemeConstants.greySecondaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(ThemeConstants.defaultBorderRadius * 2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, textAlign: TextAlign.center, style: textStyle),
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
                              : ThemeConstants.greyPrimaryColor,
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
