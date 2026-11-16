import 'package:complicity_game/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'bouncy.dart';

/// Soft clay card. [borderColor] is the darker shade of [color], used for
/// the outline and the tinted shadow.
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

  static const BorderRadius borderRadius = ThemeConstants.clayRadius;

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

    final Widget content = Flex(
      direction: widget.direction,
      mainAxisSize: horizontal ? MainAxisSize.max : MainAxisSize.min,
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
    );

    final Widget child = Bouncy(
      enabled: tappable,
      pressedScale: 0.97,
      child: GestureDetector(
        onTap: tappable ? _onTap : null,
        onTapDown: tappable ? (_) => _setPressed(true) : null,
        onTapUp: tappable ? (_) => _setPressed(false) : null,
        onTapCancel: tappable ? () => _setPressed(false) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          decoration: ThemeConstants.clay(
            widget.color,
            widget.borderColor,
            pressed: _pressed,
          ),
          foregroundDecoration: ThemeConstants.clayGloss(),
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: ThemeConstants.defaultPadding,
            vertical: horizontal ? 16.0 : 28.0,
          ),
          child: horizontal
              ? content
              // Never scrolls: it only lets the content be clipped, instead
              // of overflowing, while a Hero flight squeezes the card.
              : SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: content,
                ),
        ),
      ),
    );

    return widget.heroTag == null
        ? child
        : Hero(tag: widget.heroTag!, child: child);
  }
}
