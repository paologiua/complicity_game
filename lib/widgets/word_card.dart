import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/theme.dart';
import '../models/game_mode.dart';
import 'bouncy.dart';
import 'countdown_ring.dart';

/// The card with the word to guess. Tapping it flips it over: one face shows
/// the word and the time left before it hides itself, the other keeps it
/// secret and invites a tap to see it again.
class WordCard extends StatefulWidget {
  const WordCard({
    super.key,
    required this.word,
    required this.hidden,
    required this.countdown,
    required this.seconds,
    required this.mode,
    required this.label,
    required this.hiddenLabel,
    required this.hideHint,
    required this.revealHint,
    required this.onTap,
    this.heroTag,
  });

  final String word;
  final bool hidden;
  final Animation<double> countdown;
  final int seconds;

  /// Colours the secret face.
  final GameMode mode;

  final String label;
  final String hiddenLabel;
  final String hideHint;
  final String revealHint;
  final void Function() onTap;
  final Object? heroTag;

  static const double height = 264.0;

  /// Keeps [child] laid out at the full card size even while a Hero flight
  /// squeezes the card, so it is clipped instead of overflowing.
  static Widget unsqueezable(Widget child) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: SizedBox(
        height: height -
            2 * ThemeConstants.defaultPadding -
            2 * ThemeConstants.clayBorderWidth,
        child: child,
      ),
    );
  }

  @override
  State<WordCard> createState() => _WordCardState();
}

/// A long expression of several words ("distributore di benzina") goes on two
/// lines, broken at the space closest to its middle, so it stays big.
String _wrapped(String word) {
  if (word.length <= 14 || !word.contains(' ')) return word;

  int best = -1;
  for (int i = 0; i < word.length; i++) {
    if (word[i] == ' ' &&
        (best == -1 ||
            (i - word.length / 2).abs() < (best - word.length / 2).abs())) {
      best = i;
    }
  }

  return '${word.substring(0, best)}\n${word.substring(best + 1)}';
}

class _WordCardState extends State<WordCard>
    with SingleTickerProviderStateMixin {
  /// 0 shows the word, 1 the secret face.
  late final AnimationController _flip;
  late final Animation<double> _turn;

  @override
  void initState() {
    super.initState();
    _flip = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
      value: widget.hidden ? 1.0 : 0.0,
    );
    // The overshoot makes the card swing past flat and settle back.
    _turn = CurvedAnimation(
      parent: _flip,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    );
  }

  @override
  void didUpdateWidget(WordCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hidden != widget.hidden) {
      if (MediaQuery.of(context).disableAnimations) {
        _flip.value = widget.hidden ? 1.0 : 0.0;
      } else if (widget.hidden) {
        _flip.forward();
      } else {
        _flip.reverse();
      }
    }
  }

  @override
  void dispose() {
    _flip.dispose();
    super.dispose();
  }

  void _onTap() {
    HapticFeedback.selectionClick();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final Widget card = Semantics(
      button: true,
      label: widget.hidden ? widget.revealHint : widget.hideHint,
      child: Bouncy(
        pressedScale: 0.97,
        child: GestureDetector(
          onTap: _onTap,
          child: AnimatedBuilder(
            animation: _turn,
            builder: (BuildContext context, _) {
              final double angle = _turn.value * pi;
              final bool secret = _turn.value > 0.5;
              // The card hops towards the viewer while it turns.
              final double lift = sin(_flip.value * pi);

              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0014)
                  ..scaleByDouble(
                    1.0 + 0.07 * lift,
                    1.0 + 0.07 * lift,
                    1.0,
                    1.0,
                  )
                  ..rotateZ(-0.05 * lift)
                  ..rotateY(angle),
                child: secret
                    // Turned back, or the secret face would read mirrored.
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(pi),
                        child: _buildSecretFace(context),
                      )
                    : _buildWordFace(context),
              );
            },
          ),
        ),
      ),
    );

    return widget.heroTag == null
        ? card
        : Hero(tag: widget.heroTag!, child: card);
  }

  Widget _face({
    required Color color,
    required Color shade,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      height: WordCard.height,
      padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
      decoration: ThemeConstants.clay(color, shade),
      foregroundDecoration: ThemeConstants.clayGloss(),
      child: WordCard.unsqueezable(child),
    );
  }

  Widget _hint(BuildContext context,
      {required Widget leading, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        leading,
        const SizedBox(width: 10.0),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildWordFace(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.bodyLarge!;

    return _face(
      color: ThemeConstants.greyPrimaryColor,
      shade: ThemeConstants.greySecondaryColor,
      child: Column(
        children: [
          Text(
            widget.label,
            textAlign: TextAlign.center,
            style: textStyle.copyWith(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: ThemeConstants.mutedTextColor,
            ),
          ),
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  _wrapped(widget.word.toUpperCase()),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: textStyle.copyWith(
                    fontSize: 38.0,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
          _hint(
            context,
            leading: CountdownRing(
              animation: widget.countdown,
              seconds: widget.seconds,
              size: 38.0,
            ),
            text: widget.hideHint,
          ),
        ],
      ),
    );
  }

  Widget _buildSecretFace(BuildContext context) {
    final GameModeStyle style = widget.mode.style;
    final TextStyle textStyle = Theme.of(context).textTheme.bodyLarge!;
    final bool reduceMotion = MediaQuery.of(context).disableAnimations;

    Widget icon = const Icon(
      Icons.visibility_off_rounded,
      size: 56.0,
      color: ThemeConstants.defaultTextColor,
    );
    Widget finger = const Icon(
      Icons.touch_app_rounded,
      size: 26.0,
      color: ThemeConstants.defaultTextColor,
    );

    if (!reduceMotion) {
      icon = icon
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .rotate(
            begin: -0.02,
            end: 0.02,
            duration: const Duration(milliseconds: 1100),
            curve: Curves.easeInOut,
          );
      // The finger taps the card, to show that it can be turned back.
      finger = finger
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scaleXY(
            begin: 1.0,
            end: 0.8,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
    }

    return _face(
      color: style.cardColor,
      shade: style.cardBorderColor,
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(height: 10.0),
                Text(
                  widget.hiddenLabel,
                  textAlign: TextAlign.center,
                  style: textStyle.copyWith(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            child: _hint(context, leading: finger, text: widget.revealHint),
          ),
        ],
      ),
    );
  }
}
