import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/icons.dart';
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
    this.tooltip,
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

  /// Spoken and long-press label of a button that only shows an icon.
  final String? tooltip;

  @override
  State<CustomFloatingButton> createState() => _CustomFloatingButtonState();
}

class _CustomFloatingButtonState extends State<CustomFloatingButton> {
  @override
  Widget build(BuildContext context) {
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
        : Color.lerp(backgroundColor, Colors.black, 0.3)!;

    // The shadow belongs to the Hero, so it flies with the button between
    // screens instead of staying behind with the page.
    final Widget button = DecoratedBox(
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        shadows: [
          BoxShadow(
            color: shade.withValues(alpha: 0.38),
            blurRadius: 10.0,
            offset: const Offset(0.0, 5.0),
          ),
        ],
      ),
      child: SizedBox(
        height: widget.size,
        width: widget.text == null ? widget.size : null,
        child: widget.text == null
            ? FloatingActionButton(
                heroTag: null,
                tooltip: widget.tooltip ??
                    (widget.icon == IconsConstants.arrowBack
                        ? MaterialLocalizations.of(context).backButtonTooltip
                        : widget.icon == IconsConstants.arrowForward
                            ? MaterialLocalizations.of(context).nextPageTooltip
                            : null),
                onPressed: onPressed,
                backgroundColor: backgroundColor,
                elevation: 0,
                highlightElevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                shape: StadiumBorder(
                  side: BorderSide(
                    color: shade,
                    width: ThemeConstants.clayBorderWidth,
                  ),
                ),
                child: icon,
              )
            : FloatingActionButton.extended(
                heroTag: null,
                onPressed: onPressed,
                backgroundColor: backgroundColor,
                elevation: 0,
                highlightElevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                shape: StadiumBorder(
                  side: BorderSide(
                    color: shade,
                    width: ThemeConstants.clayBorderWidth,
                  ),
                ),
                icon: icon,
                label: text!,
              ),
      ),
    );

    // Dimming is inside the Hero too: a disabled button is already dimmed
    // while it flies in.
    final Widget dimmed = AnimatedOpacity(
      opacity: widget.enabled ? 1.0 : 0.4,
      duration: ThemeConstants.defaultDuration,
      child: button,
    );

    return IgnorePointer(
      ignoring: !widget.enabled,
      child: Bouncy(
        enabled: widget.onPressed != null,
        pressedScale: 0.9,
        child: widget.heroTag == null
            ? dimmed
            : Hero(tag: widget.heroTag!, child: dimmed),
      ),
    );
  }
}
