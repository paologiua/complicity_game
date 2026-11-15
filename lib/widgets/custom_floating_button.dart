import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/theme.dart';
import 'bouncy.dart';

class CustomFloatingButton extends StatefulWidget {
  const CustomFloatingButton({
    super.key,
    this.heroTag,
    this.onPressed,
    this.backgroundColor,
    this.icon,
    this.color,
    this.text,
    this.size = 56.0,
    this.enabled = true,
  });

  final Object? heroTag;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final IconData? icon;
  final Color? color;
  final String? text;
  final double size;

  /// A disabled button stays visible, dimmed, and ignores taps.
  final bool enabled;

  @override
  State<CustomFloatingButton> createState() => _CustomFloatingButtonState();
}

class _CustomFloatingButtonState extends State<CustomFloatingButton> {
  @override
  Widget build(BuildContext context) {
    final Object heroTag = widget.heroTag ?? Object();
    final void Function() onPressed = widget.onPressed == null
        ? () {}
        : () {
            HapticFeedback.lightImpact();
            widget.onPressed!();
          };
    final Color backgroundColor =
        widget.backgroundColor ?? ThemeConstants.greyPrimaryColor;
    final Color color = widget.color ?? ThemeConstants.defaultTextColor;

    final Icon? icon = widget.icon != null
        ? Icon(
            widget.icon,
            color: color,
          )
        : null;

    final Text? text = widget.text != null
        ? Text(
            widget.text!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: color,
                ),
          )
        : null;

    if (widget.size == 0) {
      return const SizedBox.shrink();
    }

    final Color shade = widget.backgroundColor == null
        ? ThemeConstants.greySecondaryColor
        : Color.lerp(backgroundColor, Colors.black, 0.35)!;

    return IgnorePointer(
      ignoring: !widget.enabled,
      child: AnimatedOpacity(
        opacity: widget.enabled ? 1.0 : 0.4,
        duration: ThemeConstants.defaultDuration,
        child: Bouncy(
      enabled: widget.onPressed != null,
      pressedScale: 0.9,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          shadows: [BoxShadow(color: shade, offset: const Offset(0.0, 4.0))],
        ),
        child: SizedBox(
        height: widget.size,
        width: widget.text == null ? widget.size : null,
        child: widget.text == null
            ? FloatingActionButton(
                heroTag: heroTag,
                onPressed: onPressed,
                backgroundColor: backgroundColor,
                elevation: 0,
                highlightElevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: icon,
              )
            : FloatingActionButton.extended(
                heroTag: heroTag,
                onPressed: onPressed,
                backgroundColor: backgroundColor,
                elevation: 0,
                highlightElevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                icon: icon,
                label: text!,
              ),
      ),
      ),
        ),
      ),
    );
  }
}
