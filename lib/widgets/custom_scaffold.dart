import 'package:flutter/material.dart';

import '../constants/theme.dart';
import '../models/game_mode.dart';
import 'custom_floating_button.dart';
import 'playful_background.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({
    super.key,
    required this.children,
    this.floatingButtons,
    this.mode = GameMode.classic,
  });

  final List<Widget> children;
  final List<CustomFloatingButton>? floatingButtons;

  /// The game mode that colours the frame and the animated background.
  final GameMode mode;

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    final GameModeStyle style = widget.mode.style;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: style.backgroundColor,
        body: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: ThemeConstants.entranceDuration,
                child: PlayfulBackground(
                  key: ValueKey<GameMode>(widget.mode),
                  mode: widget.mode,
                ),
              ),
            ),
            SafeArea(
              child: Stack(
                children: [
                  Padding(
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
                                        style.backgroundColor,
                                        style.backgroundColor
                                            .withValues(alpha: 0.73),
                                        style.backgroundColor.withValues(alpha: 0),
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
                                        .map(
                                          (CustomFloatingButton button) =>
                                              Padding(
                                            padding: const EdgeInsets.all(
                                              12.0,
                                            ).copyWith(top: 28.0, bottom: 20.0),
                                            child: button,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
