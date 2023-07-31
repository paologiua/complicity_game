import 'package:flutter/material.dart';

import '../constants/theme.dart';

class PillInput extends StatefulWidget {
  const PillInput({
    super.key,
    required this.color,
    required this.borderColor,
    this.initialValue,
    this.heroTag,
    this.maxLength,
    this.autofocus = false,
    this.hintText,
    this.onChange,
    this.onSubmit,
  });

  final Color color;
  final Color borderColor;
  final String? initialValue;
  final Object? heroTag;
  final int? maxLength;
  final bool autofocus;
  final String? hintText;
  final void Function(String)? onChange;
  final void Function(String)? onSubmit;

  @override
  State<PillInput> createState() => _PillInputState();
}

class _PillInputState extends State<PillInput> {
  @override
  Widget build(BuildContext context) {
    final Widget child = AnimatedContainer(
      decoration: BoxDecoration(
        color: widget.color,
        border: Border.all(
          color: widget.borderColor,
          width: ThemeConstants.defaultBorder,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(ThemeConstants.defaultBorderRadius * 2),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.defaultPadding,
        vertical: ThemeConstants.defaultPadding / 2,
      ),
      duration: ThemeConstants.defaultDuration,
      curve: ThemeConstants.defaultCurve,
      child: TextFormField(
        initialValue: widget.initialValue,
        maxLength: widget.maxLength,
        cursorColor: ThemeConstants.defaultTextColor,
        autofocus: widget.autofocus,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: widget.hintText,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          counterText: '',
          contentPadding: const EdgeInsets.all(0.0),
        ),
        onChanged: widget.onChange,
        onFieldSubmitted: widget.onSubmit,
      ),
    );

    return widget.heroTag == null
        ? child
        : Hero(tag: widget.heroTag!, child: child);
  }
}
