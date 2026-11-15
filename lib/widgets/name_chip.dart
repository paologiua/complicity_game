import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/theme.dart';
import 'bouncy.dart';

/// Small rounded button with a name (or a short label) on it.
class NameChip extends StatelessWidget {
  const NameChip({
    super.key,
    required this.label,
    required this.color,
    required this.borderColor,
    required this.onTap,
    this.icon,
  });

  final String label;
  final Color color;
  final Color borderColor;
  final IconData? icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: Bouncy(
        pressedScale: 0.94,
        child: GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          child: Container(
            constraints: const BoxConstraints(minHeight: 46.0),
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            decoration: BoxDecoration(
              gradient: ThemeConstants.surfaceGradient(color),
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              border: Border.all(color: borderColor, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: borderColor.withValues(alpha: 0.3),
                  blurRadius: 6.0,
                  offset: const Offset(0.0, 3.0),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20.0, color: ThemeConstants.defaultTextColor),
                  const SizedBox(width: 6.0),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 16.0,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
