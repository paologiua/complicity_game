import 'package:flutter/material.dart';

import '../models/game_mode.dart';

/// Drives the single background that sits behind every screen: which mode
/// colours it and how far its shapes have been swept by the navigation.
class BackgroundMotion {
  BackgroundMotion._();

  /// The mode of the screen currently on top.
  static final ValueNotifier<GameMode> mode =
      ValueNotifier<GameMode>(GameMode.classic);

  static const double _sweepSeconds = 0.9;

  static final Stopwatch clock = Stopwatch()..start();
  static final List<_Sweep> _sweeps = [];
  static double _settled = 0.0;

  /// Pushes the shapes sideways. Positive amounts move forward in the flow.
  static void sweep(double amount) {
    _sweeps.add(_Sweep(clock.elapsedMicroseconds / 1e6, amount));
  }

  /// Total distance travelled, in screen widths, at [time] seconds.
  static double travelAt(double time) {
    double travel = _settled;
    _sweeps.removeWhere((_Sweep sweep) {
      final double t = (time - sweep.start) / _sweepSeconds;
      if (t >= 1.0) {
        _settled += sweep.amount;
        travel += sweep.amount;
        return true;
      }
      travel += sweep.amount * Curves.easeOutCubic.transform(t.clamp(0.0, 1.0));
      return false;
    });
    return travel;
  }
}

class _Sweep {
  _Sweep(this.start, this.amount);

  final double start;
  final double amount;
}

/// Sweeps the background whenever a screen is pushed, replaced or popped.
class BackgroundNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute && previousRoute != null) {
      BackgroundMotion.sweep(1.0);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute is PageRoute) {
      BackgroundMotion.sweep(1.0);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute) {
      BackgroundMotion.sweep(-1.0);
    }
  }
}
