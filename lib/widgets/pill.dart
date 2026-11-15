import 'package:complicity_game/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'bouncy.dart';

class Pill extends StatefulWidget {
  const Pill({
    super.key,
    required this.color,
    required this.borderColor,
    this.direction = Axis.vertical,
    this.icon,
    this.text,
    this.child,
    this.onTap,
    this.heroTag,
  });

  final Color color;
  final Color borderColor;
  final IconData? icon;
  final String? text;
  final Widget? child;
  final Axis direction;
  final void Function()? onTap;
  final Object? heroTag;

  @override
  State<Pill> createState() => _PillState();
}

class _PillState extends State<Pill> {
  bool _pressed = false;

  void _startPress() {
    setState(() {
      _pressed = true;
    });
  }

  void _stopPress() {
    setState(() {
      _pressed = false;
    });
  }

  void _onTap() {
    HapticFeedback.selectionClick();
    widget.onTap!();
  }

  Widget _buildIcon(BuildContext context) {
    final Widget icon = Icon(
      widget.icon,
      size: ThemeConstants.defaultIconSize,
      color: ThemeConstants.defaultTextColor,
    );

    // Only the big icons of vertical pills bob: list rows stay still.
    if (widget.direction == Axis.horizontal ||
        MediaQuery.of(context).disableAnimations) {
      return icon;
    }

    return icon
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .moveY(
          begin: -3.0,
          end: 3.0,
          duration: const Duration(milliseconds: 1400),
          curve: Curves.easeInOut,
        );
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = Bouncy(
      enabled: widget.onTap != null,
      pressedScale: 0.96,
      child: GestureDetector(
        onTap: widget.onTap != null ? _onTap : null,
        onTapDown: widget.onTap != null ? (_) => _startPress() : null,
        onTapUp: widget.onTap != null ? (_) => _stopPress() : null,
        onTapCancel: widget.onTap != null ? () => _stopPress() : null,
        child: AnimatedContainer(
          duration: ThemeConstants.defaultDuration,
          curve: ThemeConstants.defaultCurve,
          decoration: BoxDecoration(
            gradient: ThemeConstants.surfaceGradient(
              !_pressed ? widget.color : widget.borderColor,
            ),
            border: Border.all(
              color: widget.borderColor,
              width: ThemeConstants.defaultBorder,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(
                ThemeConstants.defaultBorderRadius * 2,
              ),
            ),
          ),
          width: double.infinity,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(ThemeConstants.defaultBorderRadius),
            ),
            child: CustomPaint(
              painter: const _DotsPainter(),
              child: Padding(
                padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
                child: Wrap(
                  clipBehavior: Clip.hardEdge,
                  alignment: widget.direction == Axis.horizontal
                      ? WrapAlignment.start
                      : WrapAlignment.center,
                  children: [
                    Flex(
                      direction: widget.direction,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        if (widget.icon != null) _buildIcon(context),
                        if (widget.icon != null && widget.text != null)
                          const SizedBox(
                            height: ThemeConstants.defaultPadding,
                            width: ThemeConstants.defaultPadding,
                          ),
                        if (widget.text != null)
                          widget.direction == Axis.horizontal
                              ? Flexible(
                                  child: Text(
                                    widget.text!,
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                )
                              : Text(
                                  widget.text!,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                        if (widget.child != null) widget.child!
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return widget.heroTag == null
        ? child
        : Hero(tag: widget.heroTag!, child: child);
  }
}

/// Faint polka dots that give the flat surfaces some texture.
class _DotsPainter extends CustomPainter {
  const _DotsPainter();

  static const double _spacing = 22.0;
  static const double _radius = 2.5;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.white.withValues(alpha: 0.16);

    int row = 0;
    for (double y = _spacing / 2; y < size.height; y += _spacing) {
      final double shift = row.isEven ? 0.0 : _spacing / 2;
      for (double x = _spacing / 2 + shift; x < size.width; x += _spacing) {
        canvas.drawCircle(Offset(x, y), _radius, paint);
      }
      row++;
    }
  }

  @override
  bool shouldRepaint(_DotsPainter oldDelegate) => false;
}
