import 'package:flutter/material.dart';

import '../constants/theme.dart';
import '../models/game_mode.dart';
import 'custom_floating_button.dart';
import 'background_motion.dart';

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
  /// Centres [child] in the safe area, in the column every screen shares.
  Widget _column(Widget child) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.defaultPadding,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: ThemeConstants.defaultMaxWidth,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GameModeStyle style = widget.mode.style;

    // The background is shared by every screen and follows the one on top.
    if (ModalRoute.of(context)?.isCurrent ?? true) {
      final GameMode mode = widget.mode;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => BackgroundMotion.mode.value = mode,
      );
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            _column(Stack(children: widget.children)),
            if (widget.floatingButtons != null) ...[
              // Fades the content out under the buttons, across the whole
              // screen and in step with the background colour.
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                height: 116.0 + MediaQuery.of(context).padding.bottom,
                child: IgnorePointer(
                  child: TweenAnimationBuilder<Color?>(
                    tween: ColorTween(end: style.backgroundColor),
                    duration: ThemeConstants.entranceDuration,
                    builder: (BuildContext context, Color? color, _) {
                      final Color base = color ?? style.backgroundColor;
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              base,
                              base.withValues(alpha: 0.73),
                              base.withValues(alpha: 0.0),
                            ],
                            stops: const [0.0, 0.3, 1.0],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              _column(
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.floatingButtons!
                        .map(
                          (CustomFloatingButton button) => Padding(
                            padding: const EdgeInsets.all(12.0)
                                .copyWith(top: 28.0, bottom: 20.0),
                            child: button,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
