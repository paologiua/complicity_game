import 'package:complicity_game/constants/theme.dart';
import 'package:flutter/material.dart';

class Pill extends StatefulWidget {
  const Pill({
    super.key,
    required this.color,
    required this.borderColor,
    this.direction = Axis.vertical,
    this.icon,
    this.text,
    this.onTap,
    this.heroTag,
  });

  final Color color;
  final Color borderColor;
  final IconData? icon;
  final String? text;
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

  @override
  Widget build(BuildContext context) {
    final Widget child = GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.onTap != null ? (_) => _startPress() : null,
      onTapUp: widget.onTap != null ? (_) => _stopPress() : null,
      onTapCancel: widget.onTap != null ? () => _stopPress() : null,
      child: AnimatedContainer(
        duration: ThemeConstants.defaultDuration,
        curve: ThemeConstants.defaultCurve,
        decoration: BoxDecoration(
          color: !_pressed ? widget.color : widget.borderColor,
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
        padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
        width: double.infinity,
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
                if (widget.icon != null)
                  Icon(
                    widget.icon,
                    size: ThemeConstants.defaultIconSize,
                    color: ThemeConstants.defaultTextColor,
                  ),
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
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      : Text(
                          widget.text!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
              ],
            ),
          ],
        ),
      ),
    );

    return widget.heroTag == null
        ? child
        : Hero(tag: widget.heroTag!, child: child);
  }
}
