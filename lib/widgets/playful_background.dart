import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/theme.dart';
import '../models/game_mode.dart';
import 'background_motion.dart';

enum _ShapeKind { dot, ring, zigzag, wave, star, plus, symbol }

class _Shape {
  _Shape({
    required this.kind,
    required this.x,
    required this.y,
    required this.size,
    required this.phase,
    required this.period,
    required this.drift,
    required this.spin,
    required this.opacity,
    required this.dark,
    this.symbol,
  });

  final _ShapeKind kind;

  /// Position as a fraction of the available size.
  final double x;
  final double y;
  final double size;

  final double phase;
  final double period;
  final double drift;
  final double spin;
  final double opacity;

  /// Dark shapes use the mode accent, the others its pastel card colour.
  final bool dark;
  final TextPainter? symbol;
}

/// Soft gradient with slowly floating shapes and symbols of the game mode.
class PlayfulBackground extends StatefulWidget {
  const PlayfulBackground({super.key, required this.mode});

  final GameMode mode;

  @override
  State<PlayfulBackground> createState() => _PlayfulBackgroundState();
}

class _PlayfulBackgroundState extends State<PlayfulBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ticker;
  late List<_Shape> _shapes;

  @override
  void initState() {
    super.initState();
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _shapes = _buildShapes(widget.mode);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bool reduceMotion = MediaQuery.of(context).disableAnimations;
    if (reduceMotion) {
      _ticker.stop();
    } else if (!_ticker.isAnimating) {
      _ticker.repeat();
    }
  }

  @override
  void didUpdateWidget(PlayfulBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode != widget.mode) {
      _shapes = _buildShapes(widget.mode);
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  /// The layout only depends on the mode, so every screen draws the same one.
  static List<_Shape> _buildShapes(GameMode mode) {
    final Random random = Random(mode.index * 97 + 7);
    final GameModeStyle style = mode.style;
    const List<_ShapeKind> geometric = [
      _ShapeKind.dot,
      _ShapeKind.ring,
      _ShapeKind.zigzag,
      _ShapeKind.wave,
      _ShapeKind.star,
      _ShapeKind.plus,
    ];

    const int columns = 4;
    const int rows = 7;
    final List<_Shape> shapes = [];

    // A jittered grid keeps the shapes evenly spread without visible rows.
    for (int row = 0; row < rows; row++) {
      for (int column = 0; column < columns; column++) {
        final bool isSymbol = random.nextDouble() < 0.4;
        final double size = isSymbol
            ? 26.0 + random.nextDouble() * 16.0
            : 12.0 + random.nextDouble() * 22.0;
        final bool dark = random.nextDouble() < 0.35;
        final double opacity = 0.12 + random.nextDouble() * 0.12;

        TextPainter? symbol;
        if (isSymbol) {
          final IconData icon =
              style.symbols[random.nextInt(style.symbols.length)];
          symbol = TextPainter(
            textDirection: TextDirection.ltr,
            text: TextSpan(
              text: String.fromCharCode(icon.codePoint),
              style: TextStyle(
                inherit: false,
                fontFamily: icon.fontFamily,
                package: icon.fontPackage,
                fontSize: size,
                color: (dark ? style.frameColor : style.cardColor)
                    .withValues(alpha: dark ? opacity * 1.4 : opacity * 3.0),
              ),
            ),
          )..layout();
        }

        shapes.add(
          _Shape(
            kind: isSymbol
                ? _ShapeKind.symbol
                : geometric[random.nextInt(geometric.length)],
            x: (column + 0.15 + random.nextDouble() * 0.7) / columns,
            y: (row + 0.15 + random.nextDouble() * 0.7) / rows,
            size: size,
            phase: random.nextDouble() * 2 * pi,
            period: 7.0 + random.nextDouble() * 8.0,
            drift: 6.0 + random.nextDouble() * 12.0,
            spin: (random.nextDouble() - 0.5) * 0.5,
            opacity: opacity,
            dark: dark,
            symbol: symbol,
          ),
        );
      }
    }

    return shapes;
  }

  @override
  Widget build(BuildContext context) {
    final GameModeStyle style = widget.mode.style;

    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // The colours blend from one mode to the next. Cross-fading two
          // opaque backgrounds would let whatever is behind show through.
          // Same colour at the top and bottom edges, so the fades that
          // screens draw over their scrolling content blend in.
          AnimatedContainer(
            duration: ThemeConstants.entranceDuration,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  style.backgroundColor,
                  style.glowColor,
                  style.backgroundColor,
                ],
                stops: const [0.08, 0.5, 0.92],
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: ThemeConstants.entranceDuration,
            child: CustomPaint(
              key: ValueKey<GameMode>(widget.mode),
              painter: _BackgroundPainter(
                shapes: _shapes,
                style: style,
                repaint: _ticker,
              ),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  _BackgroundPainter({
    required this.shapes,
    required this.style,
    required Listenable repaint,
  }) : super(repaint: repaint);

  final List<_Shape> shapes;
  final GameModeStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final double time = BackgroundMotion.clock.elapsedMicroseconds / 1e6;
    final double travel = BackgroundMotion.travelAt(time);

    // Shapes leaving one side come back from the other.
    const double margin = 48.0;
    final double span = size.width + margin * 2;

    for (final _Shape shape in shapes) {
      final double angle = 2 * pi * time / shape.period + shape.phase;

      // Bigger shapes feel closer, so navigation sweeps them further.
      final double depth = 0.25 + (shape.size - 12.0) / 30.0 * 0.45;
      final double x = shape.x * size.width +
          cos(angle) * shape.drift * 0.6 -
          travel * size.width * depth;
      final Offset center = Offset(
        (x + margin) % span - margin,
        shape.y * size.height + sin(angle) * shape.drift,
      );

      final Color color = shape.dark
          ? style.frameColor.withValues(alpha: shape.opacity * 1.4)
          : style.cardColor.withValues(alpha: min(1.0, shape.opacity * 3.0));

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(
        shape.phase + time * shape.spin + travel * shape.spin.sign * 1.2,
      );
      _paintShape(canvas, shape, color);
      canvas.restore();
    }
  }

  void _paintShape(Canvas canvas, _Shape shape, Color color) {
    final double s = shape.size;
    final Paint fill = Paint()..color = color;
    final Paint stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = max(3.0, s * 0.16)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    switch (shape.kind) {
      case _ShapeKind.dot:
        canvas.drawCircle(Offset.zero, s * 0.3, fill);
        break;
      case _ShapeKind.ring:
        canvas.drawCircle(Offset.zero, s * 0.4, stroke);
        break;
      case _ShapeKind.zigzag:
        final Path path = Path()..moveTo(-s, 0);
        for (int i = 0; i < 4; i++) {
          path.lineTo(-s + (i + 0.5) * s * 0.5, i.isEven ? -s * 0.3 : s * 0.3);
        }
        path.lineTo(s, 0);
        canvas.drawPath(path, stroke);
        break;
      case _ShapeKind.wave:
        final Path path = Path()..moveTo(-s, 0);
        path.quadraticBezierTo(-s * 0.5, -s * 0.6, 0, 0);
        path.quadraticBezierTo(s * 0.5, s * 0.6, s, 0);
        canvas.drawPath(path, stroke);
        break;
      case _ShapeKind.star:
        final Path path = Path();
        for (int i = 0; i < 10; i++) {
          final double radius = i.isEven ? s * 0.5 : s * 0.22;
          final double a = -pi / 2 + i * pi / 5;
          final Offset point = Offset(cos(a) * radius, sin(a) * radius);
          if (i == 0) {
            path.moveTo(point.dx, point.dy);
          } else {
            path.lineTo(point.dx, point.dy);
          }
        }
        path.close();
        canvas.drawPath(path, fill);
        break;
      case _ShapeKind.plus:
        canvas.drawLine(Offset(-s * 0.4, 0), Offset(s * 0.4, 0), stroke);
        canvas.drawLine(Offset(0, -s * 0.4), Offset(0, s * 0.4), stroke);
        break;
      case _ShapeKind.symbol:
        final TextPainter painter = shape.symbol!;
        painter.paint(
          canvas,
          Offset(-painter.width / 2, -painter.height / 2),
        );
        break;
    }
  }

  @override
  bool shouldRepaint(_BackgroundPainter oldDelegate) {
    return oldDelegate.shapes != shapes || oldDelegate.style != style;
  }
}
