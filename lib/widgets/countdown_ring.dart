import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/theme.dart';

/// Ring that empties while [animation] runs, with the seconds left inside.
/// It pulses during the last two seconds.
class CountdownRing extends StatelessWidget {
  const CountdownRing({
    super.key,
    required this.animation,
    required this.seconds,
    this.size = 30.0,
  });

  final Animation<double> animation;
  final int seconds;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double remaining = (1.0 - animation.value) * seconds;
        final int label = remaining.ceil().clamp(1, seconds).toInt();
        final double pulse = remaining <= 2.0
            ? 1.0 + 0.18 * sin(remaining * 2 * pi).abs()
            : 1.0;

        return Transform.scale(
          scale: pulse,
          child: SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _RingPainter(progress: 1.0 - animation.value),
              child: Center(
                child: Text(
                  '$label',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                      ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 4.0;
    final Rect rect = (Offset.zero & size).deflate(strokeWidth / 2);

    final Paint track = Paint()
      ..color = ThemeConstants.greySecondaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final Paint arc = Paint()
      ..color = ThemeConstants.defaultTextColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 2 * pi, false, track);
    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
