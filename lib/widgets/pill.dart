import 'package:complicity_game/constants/theme.dart';
import 'package:flutter/material.dart';

class Pill extends StatefulWidget {
  const Pill({
    super.key,
    required this.color,
    required this.borderColor,
    required this.icon,
    required this.text,
    this.direction = Axis.vertical,
    this.onTap,
    this.heroTag,
  });

  final Color color;
  final Color borderColor;
  final IconData icon;
  final String text;
  final Axis direction;
  final void Function()? onTap;
  final Object? heroTag;

  @override
  State<Pill> createState() => _PillState();
}

class _PillState extends State<Pill> {
  late Color _color;

  @override
  void initState() {
    _color = widget.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.onTap != null
          ? (_) => setState(() {
                _color = widget.borderColor;
              })
          : null,
      onTapUp: widget.onTap != null
          ? (_) => setState(() {
                _color = widget.color;
              })
          : null,
      child: AnimatedContainer(
        duration: ThemeConstants.defaultDuration,
        curve: ThemeConstants.defaultCurve,
        decoration: BoxDecoration(
          color: _color,
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
          children: [
            Flex(
              direction: widget.direction,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  widget.icon,
                  size: ThemeConstants.defaultIconSize,
                  color: ThemeConstants.defaultTextColor,
                ),
                const SizedBox(
                  height: ThemeConstants.defaultPadding,
                  width: ThemeConstants.defaultPadding,
                ),
                widget.direction == Axis.horizontal
                    ? Flexible(
                        child: Text(
                          widget.text,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : Text(
                        widget.text,
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
