import 'package:complicity_game/constants/options.dart';
import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/sheets/clay_sheet.dart';
import 'package:complicity_game/sheets/player_selector_sheet.dart';
import 'package:complicity_game/widgets/custom_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:complicity_game/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../constants/icons.dart';
import '../models/player_model.dart';
import '../services/game_service.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/game_header.dart';
import '../widgets/pill.dart';
import '../widgets/word_card.dart';

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
    final AppLocalizations l10n = AppLocalizations.of(context)!;

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
                  child: WordCard(
                    heroTag: "popup",
                    // The label comes from the string that used to hold the
                    // word too, so the word can be set much larger.
                    label: l10n.mysteryWordText('').trim(),
                    word: _gameService.state.getWord(),
                    hidden: _hiddenWord,
                    countdown: _countdown,
                    seconds: OptionsConstants.wordVisibilitySeconds,
                    mode: _gameService.mode,
                    hiddenLabel: l10n.hiddenWordText,
                    hideHint: l10n.tapToHideText,
                    revealHint: l10n.tapToRevealText,
                    onTap: _hiddenWord ? _showWord : _hideWord,
                  ),
                ),
              ),
            ),
            Pill(
              color: ThemeConstants.ctaPrimaryColor,
              borderColor: ThemeConstants.ctaSecondaryColor,
              icon: Icons.celebration_rounded,
              direction: Axis.horizontal,
              text: l10n.wordFoundButtonLabel,
              onTap: () => showSelectorDialog(),
            ),
            const SizedBox(height: 14.0),
            CustomFloatingButton(
              onPressed: draw,
              icon: IconsConstants.close,
              text: l10n.drawButtonLabel,
              size: 52.0,
            ),
            const SizedBox(height: 24.0),
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
    return showClaySheet<void>(
      context: context,
      builder: (BuildContext context) => PlayerSelectorSheet(
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
