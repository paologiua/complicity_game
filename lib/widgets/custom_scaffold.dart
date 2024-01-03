import 'package:flutter/material.dart';

import '../constants/theme.dart';
import 'custom_floating_button.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({
    super.key,
    required this.children,
    this.floatingButtons,
  });

  final List<Widget> children;
  final List<CustomFloatingButton>? floatingButtons;

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
