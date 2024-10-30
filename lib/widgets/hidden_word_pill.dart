import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/widgets/pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HiddenWordPill extends StatefulWidget {
  const HiddenWordPill(
      {super.key,
      required this.greenTeamScore,
      required this.yellowTeamScore,
      this.heroTag,
      this.height,
      this.onTap});

  final int greenTeamScore;
  final int yellowTeamScore;
  final Object? heroTag;
  final double? height;
  final void Function()? onTap;

  @override
  State<HiddenWordPill> createState() => _HiddenWordPillState();
}

class _HiddenWordPillState extends State<HiddenWordPill> {
  double? _getInternalHeight() {
    if (widget.height != null) {
      return widget.height! -
            2 * ThemeConstants.defaultBorder -
            2 * ThemeConstants.defaultPadding;
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
            const SizedBox(
              height: ThemeConstants.defaultPadding,
              width: ThemeConstants.defaultPadding,
            ),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: ThemeConstants.greyPrimaryColor,
                      fontSize: 23,
                    ),
                children: <TextSpan>[
                  TextSpan(
                    text: "${widget.yellowTeamScore}",
                    style: const TextStyle(
                      color: ThemeConstants.yellowSecondaryColor,
                    ),
                  ),
                  const TextSpan(
                    text: ' - ',
                  ),
                  TextSpan(
                    text: "${widget.greenTeamScore}",
                    style: const TextStyle(
                      color: ThemeConstants.greenSecondaryColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
