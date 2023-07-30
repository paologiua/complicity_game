import 'package:flutter/material.dart';

import '../constants/theme.dart';

class CustomFloatingButton extends StatefulWidget {
  const CustomFloatingButton({
    super.key,
    this.heroTag,
    this.onPressed,
    this.backgroundColor,
    this.icon,
    this.iconColor,
  });

  final Object? heroTag;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final IconData? icon;
  final Color? iconColor;

  @override
  State<CustomFloatingButton> createState() => _CustomFloatingButtonState();
}

class _CustomFloatingButtonState extends State<CustomFloatingButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: widget.heroTag ?? Object(),
      onPressed: widget.onPressed ?? () {},
      backgroundColor:
          widget.backgroundColor ?? ThemeConstants.greyPrimaryColor,
      elevation: 0,
      highlightElevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      child: widget.icon != null
          ? Icon(
              widget.icon,
              color: widget.iconColor ?? ThemeConstants.defaultTextColor,
            )
          : null,
    );
  }
}
