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

  /// A veil of the background colour, solid at one edge of the screen and
  /// clear at the other end. It follows the colour when the mode changes.
  Widget _fade(GameModeStyle style, {required bool fromTop}) {
    return IgnorePointer(
      child: TweenAnimationBuilder<Color?>(
        tween: ColorTween(end: style.backgroundColor),
        duration: ThemeConstants.entranceDuration,
        builder: (BuildContext context, Color? color, _) {
          final Color base = color ?? style.backgroundColor;
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
                end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
                colors: [
                  base,
                  base.withValues(alpha: fromTop ? 0.9 : 0.73),
                  base.withValues(alpha: 0.0),
                ],
                stops: [0.0, fromTop ? 0.45 : 0.3, 1.0],
              ),
            ),
          );
        },
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
            // Content scrolling up fades out under the notch instead of being
            // cut off at the edge of the safe area.
            Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              height: MediaQuery.of(context).padding.top + 20.0,
              child: _fade(style, fromTop: true),
            ),
            if (widget.floatingButtons != null) ...[
              // Fades the content out under the buttons, across the whole
              // screen and in step with the background colour.
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                height: 116.0 + MediaQuery.of(context).padding.bottom,
                child: _fade(style, fromTop: false),
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
