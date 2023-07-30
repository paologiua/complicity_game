import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/theme.dart';
import 'custom_floating_button.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({
    super.key,
    required this.children,
    this.floatingButtons,
    this.foreground,
    this.foregroundOpenGetter,
    this.foregroundCloseGetter,
  });

  final List<Widget> children;
  final List<CustomFloatingButton>? floatingButtons;

  final Widget? foreground;

  final void Function(
    void Function()? open,
  )? foregroundOpenGetter;

  final void Function(
    void Function()? close,
  )? foregroundCloseGetter;

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  bool _foregroundClosed = true;

  void _openForeground() {
    if (_foregroundClosed == true) {
      setState(() {
        _foregroundClosed = false;
      });
    }
  }

  void _closeForeground() {
    if (_foregroundClosed == false) {
      setState(() {
        _foregroundClosed = true;
      });
    }
  }

  @override
  void initState() {
    if (widget.foregroundOpenGetter != null) {
      widget.foregroundOpenGetter!(_openForeground);
    }
    if (widget.foregroundCloseGetter != null) {
      widget.foregroundCloseGetter!(_closeForeground);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Scaffold(
      backgroundColor: ThemeConstants.blueSecondaryColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: ThemeConstants.bluePrimaryColor,
            border: Border.all(
              color: ThemeConstants.blueSecondaryColor,
              style: BorderStyle.solid,
              width: ThemeConstants.defaultBorder,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.defaultPadding,
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: ThemeConstants.defaultMaxWidth,
              ),
              child: Stack(
                children: [
                  ...widget.children,
                  if (widget.floatingButtons != null)
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ThemeConstants.bluePrimaryColor,
                                ThemeConstants.bluePrimaryColor
                                    .withOpacity(0.73),
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
                            children: widget.floatingButtons!
                                .map((CustomFloatingButton button) => Padding(
                                      padding: const EdgeInsets.all(
                                          ThemeConstants.defaultPadding),
                                      child: button,
                                    ))
                                .toList(),
                          ),
                        )),
                  if (widget.foreground != null)
                    AnimatedSwitcher(
                      duration: ThemeConstants.defaultDuration,
                      switchInCurve: ThemeConstants.defaultCurve,
                      switchOutCurve: ThemeConstants.defaultCurve,
                      transitionBuilder:
                          (Widget child, Animation<double> animation) =>
                              FadeTransition(opacity: animation, child: child),
                      child: !_foregroundClosed
                          ? BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 100.0,
                                sigmaY: 100.0,
                              ),
                              child: GestureDetector(
                                onTap: () {},
                                child: widget.foreground,
                              ),
                            )
                          : null,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return widget.foreground != null
        ? GestureDetector(
            onTap: _closeForeground,
            child: child,
          )
        : child;
  }
}
