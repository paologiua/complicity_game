import 'package:complicity_game/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'bouncy.dart';

/// Raised coloured card. [borderColor] is the darker shade of [color]: it
/// draws the edge under the card, which sinks when the card is pressed.
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

  static const BorderRadius borderRadius = BorderRadius.all(
    Radius.circular(ThemeConstants.defaultBorderRadius * 1.4),
  );

  @override
  State<Pill> createState() => _PillState();
}

class _PillState extends State<Pill> {
  bool _pressed = false;

  void _setPressed(bool pressed) {
    setState(() {
      _pressed = pressed;
    });
  }

  void _onTap() {
    HapticFeedback.selectionClick();
    widget.onTap!();
  }

  Widget _buildIcon(BuildContext context) {
    final bool horizontal = widget.direction == Axis.horizontal;
    final Widget icon = Icon(
      widget.icon,
      size: horizontal ? 32.0 : ThemeConstants.defaultIconSize,
      color: ThemeConstants.defaultTextColor,
    );

    // Only the big icons of vertical pills bob: list rows stay still.
    if (horizontal || MediaQuery.of(context).disableAnimations) {
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
    final bool horizontal = widget.direction == Axis.horizontal;
    final bool tappable = widget.onTap != null;
    const double lip = ThemeConstants.lipHeight;
    final double sink = _pressed ? lip - 2.0 : 0.0;

    final Widget child = Bouncy(
      enabled: tappable,
      pressedScale: 0.97,
      child: GestureDetector(
        onTap: tappable ? _onTap : null,
        onTapDown: tappable ? (_) => _setPressed(true) : null,
        onTapUp: tappable ? (_) => _setPressed(false) : null,
        onTapCancel: tappable ? () => _setPressed(false) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          margin: EdgeInsets.only(top: sink, bottom: lip - sink),
          decoration: BoxDecoration(
            gradient: ThemeConstants.surfaceGradient(widget.color),
            borderRadius: Pill.borderRadius,
            boxShadow: [
              BoxShadow(
                color: widget.borderColor,
                offset: Offset(0.0, lip - sink),
              ),
            ],
          ),
          width: double.infinity,
          child: ClipRRect(
            borderRadius: Pill.borderRadius,
            child: CustomPaint(
              painter: const _DotsPainter(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ThemeConstants.defaultPadding,
                  vertical: horizontal ? 16.0 : 28.0,
                ),
                child: Flex(
                  direction: widget.direction,
                  mainAxisSize:
                      horizontal ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (widget.icon != null) _buildIcon(context),
                    if (widget.icon != null && widget.text != null)
                      SizedBox(
                        height: ThemeConstants.defaultPadding,
                        width: horizontal ? 12.0 : 0.0,
                      ),
                    if (widget.text != null)
                      horizontal
                          ? Flexible(
                              child: Text(
                                widget.text!,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
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
    final Paint paint = Paint()..color = Colors.white.withValues(alpha: 0.14);

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
