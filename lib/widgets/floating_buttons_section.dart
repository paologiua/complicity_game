import 'package:complicity_game/models/floating_button_model.dart';
import 'package:flutter/material.dart';
import '../constants/theme.dart';

class FloatingButtonsSection extends StatefulWidget {
  const FloatingButtonsSection({
    super.key,
    required this.buttons,
  });

  final List<FloatingButtonModel> buttons;

  @override
  State<FloatingButtonsSection> createState() => _FloatingButtonsSectionState();
}

class _FloatingButtonsSectionState extends State<FloatingButtonsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeConstants.bluePrimaryColor,
            ThemeConstants.bluePrimaryColor.withOpacity(0.73),
            ThemeConstants.bluePrimaryColor.withOpacity(0),
          ],
          begin: const FractionalOffset(0.0, 1.0),
          end: const FractionalOffset(0.0, 0.0),
          stops: const [0.0, 0.3, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.buttons
            .map((FloatingButtonModel button) => Padding(
                  padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
                  child: FloatingActionButton(
                    heroTag: button.key,
                    onPressed: button.action,
                    backgroundColor: ThemeConstants.greyPrimaryColor,
                    elevation: 0,
                    highlightElevation: 0,
                    child: Icon(
                      button.icon,
                      color: ThemeConstants.defaultTextStyle.color,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
