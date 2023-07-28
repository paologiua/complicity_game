import 'package:complicity_game/constants/theme.dart';
import 'package:flutter/material.dart';

class Popup extends StatefulWidget {
  const Popup({
    super.key,
    required this.color,
    required this.borderColor,
    required this.icon,
    required this.text,
  });

  final Color color;
  final Color borderColor;
  final IconData icon;
  final String text;

  @override
  State<Popup> createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: ThemeConstants.defaultPadding,
      ),
      constraints: const BoxConstraints(
        maxWidth: ThemeConstants.defaultMaxWidth,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeConstants.bluePrimaryColor,
            ThemeConstants.bluePrimaryColor.withOpacity(0.0),
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
          stops: const [0.8, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: widget.color,
          border: Border.all(
            color: widget.borderColor,
            width: ThemeConstants.defaultBorder,
          ),
          borderRadius: const BorderRadius.all(
              Radius.circular(ThemeConstants.defaultBorder * 2)),
        ),
        padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
        width: double.infinity,
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          runSpacing: ThemeConstants.defaultPadding,
          children: <Widget>[
            Icon(
              widget.icon,
              size: ThemeConstants.defaultIconSize,
              color: ThemeConstants.defaultTextColor,
            ),
            Text(
              widget.text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
