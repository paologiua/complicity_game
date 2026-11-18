import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/theme.dart';
import '../models/player_model.dart';

/// Both teams' scores with a segmented bar that fills up to the target.
class ScoreBoard extends StatelessWidget {
  const ScoreBoard({
    super.key,
    required this.greenScore,
    required this.yellowScore,
    required this.targetScore,
    this.highlight,
  });

  final int greenScore;
  final int yellowScore;
  final int targetScore;

  /// The team that just scored: its number and newest segment pop in.
  final Team? highlight;

  /// Longer than the page transition. The board flies between screens as a
  /// Hero, which shows a second copy of it during the flight: an animation
  /// starting earlier would play once on that copy and again on the real one.
  static const Duration highlightDelay = Duration(milliseconds: 650);

  /// Two rows of fixed height, their gap, the padding and the clay border:
  /// the board is this tall whatever the size of the text.
  static const double height =
      2 * _TeamRow.height + 6.0 + 2 * 10.0 + 2 * ThemeConstants.clayBorderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: ThemeConstants.clay(
        ThemeConstants.greyPrimaryColor,
        ThemeConstants.greySecondaryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(ThemeConstants.defaultBorderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TeamRow(
            team: Team.yellow,
            score: yellowScore,
            targetScore: targetScore,
            highlighted: highlight == Team.yellow,
          ),
          const SizedBox(height: 6.0),
          _TeamRow(
            team: Team.green,
            score: greenScore,
            targetScore: targetScore,
            highlighted: highlight == Team.green,
          ),
        ],
      ),
    );
  }
}

class _TeamRow extends StatelessWidget {
  /// Height of a row, set by the score badge at its start.
  static const double height = 26.0;

  const _TeamRow({
    required this.team,
    required this.score,
    required this.targetScore,
    required this.highlighted,
  });

  final Team team;
  final int score;
  final int targetScore;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final bool animate =
        highlighted && !MediaQuery.of(context).disableAnimations;

    Widget number = Text(
      '$score',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: 15.0,
            fontWeight: FontWeight.w700,
            height: 1.0,
          ),
    );

    if (animate) {
      // Swells and springs back. It starts at rest, so nothing shows while
      // the board is still flying in from the previous screen.
      number = number
          .animate(delay: ScoreBoard.highlightDelay)
          .scaleXY(
            begin: 1.0,
            end: 2.2,
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
          )
          .then()
          .scaleXY(
            begin: 1.0,
            end: 1.0 / 2.2,
            duration: const Duration(milliseconds: 650),
            curve: Curves.elasticOut,
          );
    }

    return Row(
      children: [
        Container(
          width: 26.0,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: team.color,
            shape: BoxShape.circle,
            border: Border.all(color: team.borderColor, width: 2.0),
          ),
          child: number,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Row(
            children: [
              for (int index = 0; index < targetScore; index++)
                Expanded(
                  child: _Segment(
                    color: team.borderColor,
                    filled: index < score,
                    animated: animate && index == score - 1,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.color,
    required this.filled,
    required this.animated,
  });

  final Color color;
  final bool filled;
  final bool animated;

  @override
  Widget build(BuildContext context) {
    Widget fill = Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
    );

    if (animated) {
      fill = fill.animate(delay: ScoreBoard.highlightDelay).scaleX(
            begin: 0.0,
            end: 1.0,
            alignment: Alignment.centerLeft,
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutBack,
          );
    }

    return Container(
      height: 10.0,
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        color: ThemeConstants.blackPrimaryColor.withValues(alpha: 0.10),
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      child: filled ? fill : null,
    );
  }
}
