import 'package:flutter/material.dart';

import '../constants/theme.dart';

/// Heading of a screen or sheet: plain text on the background, never a card,
/// so that cards are left for content and buttons.
class ScreenTitle extends StatelessWidget {
  const ScreenTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.padding = const EdgeInsets.only(top: 24.0, bottom: 16.0),
  });

  final String title;
  final String? subtitle;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.bodyLarge!;

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            header: true,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: textStyle.copyWith(
                fontSize: 26.0,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8.0),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: textStyle.copyWith(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: ThemeConstants.mutedTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
