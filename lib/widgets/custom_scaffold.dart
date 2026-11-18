import 'package:flutter/material.dart';

import '../constants/theme.dart';
import '../models/game_mode.dart';
import 'custom_floating_button.dart';
import 'background_motion.dart';
import 'game_header.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({
    super.key,
    required this.children,
    this.floatingButtons,
    this.header,
    this.mode = GameMode.classic,
  });

  final List<Widget> children;
  final List<CustomFloatingButton>? floatingButtons;

  /// A bar pinned at the top, [GameHeader.extent] tall. Content scrolls under
  /// it and fades out, as it does under the [floatingButtons].
  final Widget? header;

  /// The game mode that colours the frame and the animated background.
  final GameMode mode;

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  /// Taken by the list of the screen, so the scrollbar can be drawn at the
  /// edge of the screen instead of next to the narrow column.
  final ScrollController _scroll = ScrollController();

  static const Set<TargetPlatform> _desktop = {
    TargetPlatform.linux,
    TargetPlatform.macOS,
    TargetPlatform.windows,
  };

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// The screen with one scrollbar at its right edge, on the platforms that
  /// show one, for the list of the screen. The scroll view of the screen
  /// takes [_scroll] as its primary controller and keeps no bar of its own.
  Widget _scrollable(BuildContext context, Widget screen) {
    final Widget withoutOwnBar = PrimaryScrollController(
      controller: _scroll,
      automaticallyInheritForPlatforms: TargetPlatform.values.toSet(),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: screen,
      ),
    );

    if (!_desktop.contains(Theme.of(context).platform)) {
      return withoutOwnBar;
    }

    return Scrollbar(
      controller: _scroll,
      // Only the list of the screen, not the cards that never scroll.
      notificationPredicate: (ScrollNotification notification) =>
          notification.depth == 0 &&
          _scroll.positions.any(
            (ScrollPosition position) =>
                position.context.notificationContext == notification.context,
          ),
      child: withoutOwnBar,
    );
  }

  /// How far below the header the content is still fading in.
  static const double _headerFadeDepth = 16.0;

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
  ///
  /// The veil under a bar of buttons is light, so what scrolls under the bar
  /// still shows through; the one under the notch is denser, as there is
  /// nothing to see there.
  Widget _fade(
    GameModeStyle style, {
    required bool fromTop,
    bool underBar = false,
  }) {
    final bool light = underBar || !fromTop;
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
                  base.withValues(alpha: light ? 0.73 : 0.9),
                  base.withValues(alpha: 0.0),
                ],
                stops: [0.0, light ? 0.3 : 0.45, 1.0],
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

    // The back button and gesture go back a screen, like the arrows do. The
    // screens of a game in progress ask first: see GameExit in router.dart.
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _scrollable(
        context,
        Stack(
          children: [
            _column(Stack(children: widget.children)),
            // Content scrolling up fades out under the notch, or under the
            // header, instead of being cut off at their edge.
            if (widget.header == null)
              Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                height: MediaQuery.of(context).padding.top + 20.0,
                child: _fade(style, fromTop: true),
              )
            else ...[
              Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                height: MediaQuery.of(context).padding.top +
                    GameHeader.extent +
                    _headerFadeDepth,
                // The same veil as under the buttons at the bottom, upside down.
                child: _fade(style, fromTop: true, underBar: true),
              ),
              _column(
                  Align(alignment: Alignment.topCenter, child: widget.header)),
            ],
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
