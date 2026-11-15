import 'dart:math';

import 'package:flutter/material.dart';

/// Endless fireworks show. Every burst is a pure function of the elapsed
/// time, so nothing has to be simulated frame by frame.
class Fireworks extends StatefulWidget {
  const Fireworks({super.key, required this.colors});

  final List<Color> colors;

  @override
  State<Fireworks> createState() => _FireworksState();
}

class _FireworksState extends State<Fireworks>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ticker;
  final Stopwatch _clock = Stopwatch();

  @override
  void initState() {
    super.initState();
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (MediaQuery.of(context).disableAnimations) {
      _ticker.stop();
      _clock.stop();
    } else if (!_ticker.isAnimating) {
      _clock.start();
      _ticker.repeat();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _FireworksPainter(
            clock: _clock,
            colors: widget.colors,
            repaint: _ticker,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _FireworksPainter extends CustomPainter {
  _FireworksPainter({
    required this.clock,
    required this.colors,
    required Listenable repaint,
  }) : super(repaint: repaint);

  final Stopwatch clock;
  final List<Color> colors;

  /// Seconds between two launches.
  static const double _interval = 0.55;

  /// Seconds a rocket takes to reach the point where it explodes.
  static const double _rise = 0.6;

  /// Seconds the sparks stay visible after the explosion.
  static const double _burst = 1.5;

  static const int _sparks = 28;

  @override
  void paint(Canvas canvas, Size size) {
    final double time = clock.elapsedMicroseconds / 1e6;
    final int newest = (time / _interval).floor();
    final int oldest = max(0, newest - ((_rise + _burst) / _interval).ceil());

    for (int index = oldest; index <= newest; index++) {
      final double age = time - index * _interval;
      if (age < 0 || age > _rise + _burst) {
        continue;
      }

      // Seeding with the launch index gives each rocket a stable shape.
      final Random random = Random(index * 7919 + 13);
      final Offset target = Offset(
        size.width * (0.12 + random.nextDouble() * 0.76),
        size.height * (0.10 + random.nextDouble() * 0.45),
      );
      final Color color = colors[random.nextInt(colors.length)];
      final double power = size.shortestSide * (0.20 + random.nextDouble() * 0.16);

      if (age < _rise) {
        _paintRocket(canvas, size, target, color, age / _rise);
      } else {
        _paintBurst(canvas, target, color, power, (age - _rise) / _burst, random);
      }
    }
  }

  void _paintRocket(
    Canvas canvas,
    Size size,
    Offset target,
    Color color,
    double progress,
  ) {
    final double eased = Curves.easeOutCubic.transform(progress);
    final Offset start = Offset(target.dx, size.height);
    final Offset head = Offset.lerp(start, target, eased)!;
    final Offset tail = Offset.lerp(start, target, max(0.0, eased - 0.12))!;

    canvas.drawLine(
      tail,
      head,
      Paint()
        ..color = color.withValues(alpha: 0.9)
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round,
    );
  }

  void _paintBurst(
    Canvas canvas,
    Offset center,
    Color color,
    double power,
    double progress,
    Random random,
  ) {
    final double spread = Curves.easeOutCubic.transform(progress);
    final double fade = 1.0 - Curves.easeInQuad.transform(progress);
    final double gravity = power * 0.55 * progress * progress;
    final Paint paint = Paint()..strokeCap = StrokeCap.round;

    for (int i = 0; i < _sparks; i++) {
      final double angle = 2 * pi * i / _sparks + random.nextDouble() * 0.25;
      final double reach = power * (0.55 + random.nextDouble() * 0.45);
      final Offset direction = Offset(cos(angle), sin(angle));
      final Offset drop = Offset(0, gravity);

      final Offset head = center + direction * (reach * spread) + drop;
      final Offset tail =
          center + direction * (reach * max(0.0, spread - 0.10)) + drop;

      paint
        ..color = (i.isEven ? color : Colors.white).withValues(alpha: fade)
        ..strokeWidth = 2.0 + 2.5 * fade;
      canvas.drawLine(tail, head, paint);
    }
  }

  @override
  bool shouldRepaint(_FireworksPainter oldDelegate) {
    return oldDelegate.colors != colors;
  }
}
