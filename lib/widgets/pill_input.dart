import 'package:flutter/material.dart';

import '../constants/theme.dart';

/// Text field on a tinted clay surface, with an icon that pops when it
/// changes (for instance when the player moves to the other team).
class PillInput extends StatelessWidget {
  const PillInput({
    super.key,
    required this.controller,
    required this.color,
    required this.borderColor,
    this.icon,
    this.maxLength,
    this.autofocus = false,
    this.hintText,
    this.onSubmit,
  });

  final TextEditingController controller;
  final Color color;
  final Color borderColor;
  final IconData? icon;
  final int? maxLength;
  final bool autofocus;
  final String? hintText;
  final void Function(String)? onSubmit;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.bodyLarge!;

    return AnimatedContainer(
      duration: ThemeConstants.defaultDuration,
      curve: ThemeConstants.defaultCurve,
      decoration: BoxDecoration(
        color: ThemeConstants.lighten(color, 0.45),
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        border: Border.all(color: borderColor, width: 2.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
      child: Row(
        children: [
          if (icon != null) ...[
            AnimatedSwitcher(
              duration: ThemeConstants.entranceDuration,
              switchInCurve: ThemeConstants.bounceCurve,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: RotationTransition(
                    turns: Tween<double>(begin: -0.15, end: 0.0)
                        .animate(animation),
                    child: child,
                  ),
                );
              },
              child: Container(
                key: ValueKey<IconData>(icon!),
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: 2.0),
                ),
                child: Icon(
                  icon,
                  size: 22.0,
                  color: ThemeConstants.defaultTextColor,
                ),
              ),
            ),
            const SizedBox(width: 12.0),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              maxLength: maxLength,
              cursorColor: ThemeConstants.defaultTextColor,
              autofocus: autofocus,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              style: textStyle,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: textStyle.copyWith(
                  color: ThemeConstants.mutedTextColor,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              onSubmitted: onSubmit,
            ),
          ),
        ],
      ),
    );
  }
}
