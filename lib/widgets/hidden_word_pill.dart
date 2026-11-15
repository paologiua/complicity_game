import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/widgets/pill.dart';
import 'package:flutter/material.dart';
import 'package:complicity_game/l10n/app_localizations.dart';

class HiddenWordPill extends StatefulWidget {
  const HiddenWordPill(
      {super.key,
      this.heroTag,
      this.height,
      this.onTap});

  final Object? heroTag;
  final double? height;
  final void Function()? onTap;

  @override
  State<HiddenWordPill> createState() => _HiddenWordPillState();
}

class _HiddenWordPillState extends State<HiddenWordPill> {
  double? _getInternalHeight() {
    if (widget.height != null) {
      // Same height as the pill that shows the word: the card does not jump.
      return widget.height! - 2 * 28.0;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Pill(
      heroTag: widget.heroTag,
      color: ThemeConstants.blackPrimaryColor,
      borderColor: ThemeConstants.blackSecondaryColor,
      onTap: widget.onTap,
      child: SizedBox(
        height: _getInternalHeight(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.hide_source_rounded,
              size: ThemeConstants.defaultIconSize,
              color: ThemeConstants.greyPrimaryColor,
            ),
            const SizedBox(
              height: ThemeConstants.defaultPadding,
              width: ThemeConstants.defaultPadding,
            ),
            Text(
              AppLocalizations.of(context)!.hiddenWordText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: ThemeConstants.greyPrimaryColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
