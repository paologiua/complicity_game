import 'package:complicity_game/constants/options.dart';
import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/dialogs/player_selector_dialog.dart';
import 'package:complicity_game/widgets/custom_floating_button.dart';
import 'package:complicity_game/widgets/hidden_word_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:complicity_game/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../constants/icons.dart';
import '../models/player_model.dart';
import '../services/game_service.dart';
import '../widgets/countdown_ring.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/game_header.dart';
import '../widgets/pill.dart';
import '../widgets/size_measurer.dart';

class GameProgressScreen extends StatefulWidget {
  const GameProgressScreen({super.key});

  @override
  State<GameProgressScreen> createState() => _GameProgressScreenState();
}

class _GameProgressScreenState extends State<GameProgressScreen>
    with SingleTickerProviderStateMixin {
  late GameService _gameService;
  late AnimationController _countdown;

  bool _hiddenWord = false;
  double _popupHeight = 0.0;

  @override
  void initState() {
    _gameService = context.read<GameService>();
    _countdown = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: OptionsConstants.wordVisibilitySeconds,
      ),
    )
      ..addStatusListener(_onCountdownStatus)
      ..forward();
    super.initState();
  }

  @override
  void dispose() {
    _countdown.dispose();
    super.dispose();
  }

  void _onCountdownStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      HapticFeedback.mediumImpact();
      setState(() {
        _hiddenWord = true;
      });
    }
  }

  void _hideWord() {
    _countdown.stop();
    setState(() {
      _hiddenWord = true;
    });
  }

  void _showWord() {
    setState(() {
      _hiddenWord = false;
    });
    _countdown.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final Widget wordPill = _hiddenWord
        ? HiddenWordPill(
            heroTag: "popup",
            greenTeamScore: _gameService.state.getScore(Team.green),
            yellowTeamScore: _gameService.state.getScore(Team.yellow),
            height: _popupHeight,
            onTap: _showWord,
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
              text: AppLocalizations.of(context)!.mysteryWordText(
                _gameService.state.getWord().toUpperCase(),
              ),
              onTap: _hideWord,
            ),
          );

    return CustomScaffold(
      mode: _gameService.mode,
      children: [
        Column(
          children: [
            const GameHeader(),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    vertical: ThemeConstants.defaultPadding,
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.all(ThemeConstants.defaultPadding),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.24),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          ThemeConstants.defaultBorderRadius * 3,
                        ),
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
                            text:
                                AppLocalizations.of(context)!.drawButtonLabel,
                            size: 64.0,
                          ),
                        ),
                        Stack(
                          children: [
                            // Replayed every time the word is hidden or
                            // shown, so the swap reads as a card flipping.
                            MediaQuery.of(context).disableAnimations
                                ? wordPill
                                : Animate(
                                    key: ValueKey<bool>(_hiddenWord),
                                    effects: const [
                                      FlipEffect(
                                        begin: 0.25,
                                        end: 0.0,
                                        direction: Axis.horizontal,
                                        duration: Duration(milliseconds: 350),
                                        curve: Curves.easeOutBack,
                                      ),
                                    ],
                                    child: wordPill,
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
                                  padding: const EdgeInsets.all(12.0),
                                  child: _hiddenWord
                                      ? const Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: Icon(
                                            Icons.lock_open_rounded,
                                            size:
                                                ThemeConstants.defaultFontSize,
                                            color:
                                                ThemeConstants.greyPrimaryColor,
                                          ),
                                        )
                                      : CountdownRing(
                                          animation: _countdown,
                                          seconds: OptionsConstants
                                              .wordVisibilitySeconds,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Pill(
                          color: ThemeConstants.limePrimaryColor,
                          borderColor: ThemeConstants.limeSecondaryColor,
                          icon: Icons.celebration_rounded,
                          direction: Axis.horizontal,
                          text: AppLocalizations.of(context)!
                              .wordFoundButtonLabel,
                          onTap: () => showSelectorDialog(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void win(Team? team) {
    _countdown.stop();
    _gameService.state.resolve(team);

    Navigator.pushReplacementNamed(
      context,
      "/game/result",
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
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }
}
