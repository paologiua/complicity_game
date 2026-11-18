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
    if (widget.size == 0) {
      return const SizedBox.shrink();
    }

    final Widget body = _ButtonBody(button: widget);

    return IgnorePointer(
      ignoring: !widget.enabled,
      child: Bouncy(
        enabled: widget.onPressed != null,
        pressedScale: 0.9,
        child: widget.heroTag == null
            ? body
            : Hero(
                tag: widget.heroTag!,
                createRectTween: ThemeConstants.heroRectTween,
                flightShuttleBuilder: _flightShuttle,
                child: body,
              ),
      ),
    );
  }

  /// While a button turns into the one of the next screen, the old one fades
  /// away at once and the new label sits still at full size: the pill uncovers
  /// it like a curtain as it widens.
  static Widget _flightShuttle(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final CustomFloatingButton? from =
        fromHeroContext.findAncestorWidgetOfExactType<CustomFloatingButton>();
    final CustomFloatingButton? to =
        toHeroContext.findAncestorWidgetOfExactType<CustomFloatingButton>();
    if (from == null || to == null) {
      return (toHeroContext.widget as Hero).child;
    }

    final Animation<double> progress = direction == HeroFlightDirection.push
        ? animation
        : ReverseAnimation(animation);

    return Stack(
      fit: StackFit.expand,
      children: [
        _ButtonBody(
          button: to,
          label: CurvedAnimation(
            parent: progress,
            curve: const Interval(0.05, 0.25, curve: Curves.easeOut),
          ),
        ),
        FadeTransition(
          opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: progress,
              curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
            ),
          ),
          child: _ButtonBody(button: from),
        ),
      ],
    );
  }
}

class _ButtonBody extends StatelessWidget {
  const _ButtonBody({required this.button, this.label});

  final CustomFloatingButton button;

  /// Opacity of the text during a flight; null when the button is at rest.
  final Animation<double>? label;

  CustomFloatingButton get widget => button;

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
            // Not a FloatingActionButton.extended: its label cannot shrink, so
            // while the button grows out of a smaller one between two screens
            // the text would spill over the pill. Here it is clipped by it.
            : Material(
                color: backgroundColor,
                clipBehavior: Clip.antiAlias,
                shape: StadiumBorder(
                  side: BorderSide(
                    color: shade,
                    width: ThemeConstants.clayBorderWidth,
                  ),
                ),
                child: InkWell(
                  onTap: onPressed,
                  customBorder: const StadiumBorder(),
                  child: Semantics(
                    button: true,
                    // Wider than its content (the first part of a flight
                    // towards a smaller button), the pill keeps it centred.
                    child: LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        child: Container(
                          height: widget.size,
                          constraints: BoxConstraints(
                            minWidth: constraints.minWidth,
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: icon == null ? 20.0 : 16.0,
                              end: 20.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (icon != null) ...[
                                  icon,
                                  const SizedBox(width: 8.0),
                                ],
                                label == null
                                    ? text!
                                    : FadeTransition(
                                        opacity: label!, child: text),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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

    return dimmed;
  }
}
