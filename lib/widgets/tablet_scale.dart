import 'package:flutter/widgets.dart';

/// Makes the whole app bigger on tablets, so that it fills the screen as it
/// does on a phone instead of sitting small in the middle.
///
/// The app is laid out on a smaller, phone-like screen and then scaled up to
/// the real one. Phones are left untouched.
class TabletScale extends StatelessWidget {
  const TabletScale({super.key, required this.child});

  final Widget child;

  /// Below this shortest side the device is a phone.
  static const double _tabletShortestSide = 600.0;

  /// The phone-like screen the app is laid out on: wide enough for the
  /// content column, tall enough for the longest screen.
  static const double _phoneWidth = 430.0;
  static const double _phoneHeight = 760.0;

  static const double _maxScale = 2.0;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final Size size = media.size;

    if (size.isEmpty || size.shortestSide < _tabletShortestSide) {
      return child;
    }

    final double scale = [
      size.width / _phoneWidth,
      size.height / _phoneHeight,
      _maxScale,
    ].reduce((double a, double b) => a < b ? a : b);

    if (scale <= 1.0) {
      return child;
    }

    final Size scaledSize = size / scale;

    return FittedBox(
      fit: BoxFit.fill,
      alignment: Alignment.topLeft,
      child: SizedBox.fromSize(
        size: scaledSize,
        child: MediaQuery(
          data: media.copyWith(
            size: scaledSize,
            padding: media.padding / scale,
            viewPadding: media.viewPadding / scale,
            viewInsets: media.viewInsets / scale,
          ),
          child: child,
        ),
      ),
    );
  }
}
