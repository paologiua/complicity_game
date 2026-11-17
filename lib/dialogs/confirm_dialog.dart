import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/icons.dart';
import '../constants/theme.dart';
import '../widgets/custom_floating_button.dart';
import '../widgets/pill.dart';

/// Asks a yes/no question. Pops with true when the user confirms.
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.text,
    required this.confirmLabel,
    required this.cancelLabel,
    this.icon,
    this.confirmIcon = Icons.logout_rounded,
  });

  final String text;
  final String confirmLabel;
  final String cancelLabel;
  final IconData? icon;

  /// Icon of the confirming button: leaving the game, unless told otherwise.
  final IconData confirmIcon;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
      child: Dialog(
        insetPadding: const EdgeInsets.all(0.0),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: ThemeConstants.defaultMaxWidth,
            ),
            margin: const EdgeInsets.all(ThemeConstants.defaultPadding * 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Pill(
                  color: ThemeConstants.greyPrimaryColor,
                  borderColor: ThemeConstants.greySecondaryColor,
                  icon: icon,
                  text: text,
                ),
                const SizedBox(height: ThemeConstants.defaultPadding),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: ThemeConstants.defaultPadding,
                  runSpacing: ThemeConstants.defaultPadding,
                  children: [
                    CustomFloatingButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      icon: IconsConstants.close,
                      text: cancelLabel,
                      size: 64.0,
                    ),
                    CustomFloatingButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      icon: confirmIcon,
                      text: confirmLabel,
                      backgroundColor: ThemeConstants.blackPrimaryColor,
                      color: ThemeConstants.greyPrimaryColor,
                      size: 64.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
