import 'dart:async';

import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/dialogs/confirm_dialog.dart';
import 'package:complicity_game/l10n/app_localizations.dart';
import 'package:complicity_game/screens/game_over_screen.dart';
import 'package:complicity_game/screens/game_progress_screen.dart';
import 'package:complicity_game/screens/game_result_screen.dart';
import 'package:complicity_game/screens/game_rules_screen.dart';
import 'package:complicity_game/screens/game_setup_screen.dart';
import 'package:complicity_game/screens/game_start_screen.dart';
import 'package:complicity_game/screens/home_screen.dart';
import 'package:complicity_game/screens/splash_screen.dart';
import 'package:complicity_game/screens/team_selector_screen.dart';
import 'package:complicity_game/widgets/background_motion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Where each screen lives. On the web these are the addresses of the
/// screens, so the back button of the browser walks back through them.
abstract final class Paths {
  static const String splash = '/splash';
  static const String home = '/';
  static const String rules = '/rules';
  static const String players = '/players';
  static const String setup = '/game/setup';
  static const String turn = '/game/start';
  static const String word = '/game/progress';
  static const String result = '/game/result';
  static const String over = '/game/over';
}

/// Whether the splash has done its job in this run of the app. Until then
/// every address leads to the splash: a link or a reload always starts the
/// game from the beginning, with the saved players and the words loaded.
abstract final class AppStart {
  static bool done = false;
}

/// Once a game has started, going back means leaving the game: the back
/// button, the back gesture and the X of the game header all lead home.
/// While the game is on they ask first; on the winner screen they go home
/// straight away, the game being over.
///
/// The game moving on by itself, from one of its screens to the next, again
/// or home at the end, goes through [GameExit.allow] and is never stopped.
abstract final class GameExit {
  static bool _allowed = false;

  /// Up while the players walk out of a game: the home then comes back
  /// without the card of the game flying into its start button, which only
  /// makes sense when the game has been played to the end.
  static final ValueNotifier<bool> walkingOut = ValueNotifier<bool>(false);

  /// Runs [navigate] without asking: go_router calls [GoRoute.onExit] while
  /// the navigation starts, so the flag is only up for its duration.
  static void allow(VoidCallback navigate) {
    _allowed = true;
    try {
      navigate();
    } finally {
      _allowed = false;
    }
  }

  /// [GoRoute.onExit] of the screens of a game. Other than for the game's
  /// own steps it always stays, and heads home itself once the players agree.
  static FutureOr<bool> confirm(BuildContext context, GoRouterState state) {
    if (_allowed) {
      return true;
    }

    final GoRouter router = GoRouter.of(context);
    void goHome() {
      walkingOut.value = true;
      Future<void>.microtask(() async {
        await backHome(router);
        // Long enough for the way back home to be over.
        await Future<void>.delayed(const Duration(milliseconds: 700));
        walkingOut.value = false;
      });
    }

    if (state.matchedLocation == Paths.over) {
      goHome();
      return false;
    }

    return _ask(context).then((bool leave) {
      if (leave) {
        goHome();
      }
      return false;
    });
  }

  /// Takes the players home from a game the way the back button would: the
  /// game screen slides off and the home comes back in from the side.
  ///
  /// Going home in one step would drop the screens between the two at once,
  /// leaving the home unaware of the screen closing over it, so it would just
  /// sit still in the middle. The screens in between are removed first, out
  /// of sight under the game, and the game is closed on the next frame.
  static Future<void> backHome(GoRouter router) async {
    final GoRouterDelegate delegate = router.routerDelegate;
    final RouteMatchList stack = delegate.currentConfiguration;

    if (stack.matches.length > 2) {
      // Home and the screen on top, nothing in between. RouteMatchList.remove
      // would also drop everything above the match it removes.
      final RouteMatchList homeAndTop = RouteMatchList(
        matches: [stack.matches.first, stack.matches.last],
        uri: stack.uri,
        extra: stack.extra,
        pathParameters: stack.pathParameters,
      );
      allow(() => delegate.setNewRoutePath(homeAndTop));
      await WidgetsBinding.instance.endOfFrame;
    }

    allow(() => router.go(Paths.home));
  }

  static Future<bool> _ask(BuildContext context) async {
    HapticFeedback.lightImpact();

    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final DialogRoute<bool> dialog = DialogRoute<bool>(
      context: context,
      barrierColor: ThemeConstants.scrimColor,
      barrierDismissible: false,
      builder: (BuildContext context) => ConfirmDialog(
        icon: Icons.logout_rounded,
        text: l10n.exitGameText,
        confirmLabel: l10n.exitButtonLabel,
        cancelLabel: l10n.cancelButtonLabel,
      ),
    );

    final bool confirmed =
        await Navigator.of(context).push<bool>(dialog) ?? false;

    // Leave only once the dialog has faded out: while it is still on top,
    // the screen of the game would be taken away from under it, with no
    // transition back home.
    await _closed(dialog);

    return confirmed;
  }

  static Future<void> _closed(ModalRoute<Object?> route) {
    final Animation<double>? animation = route.animation;
    if (animation == null || animation.status == AnimationStatus.dismissed) {
      return Future<void>.value();
    }

    final Completer<void> closed = Completer<void>();
    void listener(AnimationStatus status) {
      if (status == AnimationStatus.dismissed) {
        animation.removeStatusListener(listener);
        closed.complete();
      }
    }

    animation.addStatusListener(listener);
    return closed.future;
  }
}

GoRoute _screen(String path, Widget screen, {bool inGame = false}) {
  return GoRoute(
    path: path,
    pageBuilder: (BuildContext context, GoRouterState state) =>
        _page(state, screen),
    onExit: inGame ? GameExit.confirm : null,
  );
}

/// A Material page, so the screens slide with the transition of the theme
/// and the shared buttons fly between them. go_router would pick it by
/// itself, but it does not recognise the MaterialApp of this Flutter version
/// and falls back to pages with no transition at all.
Page<void> _page(GoRouterState state, Widget screen) {
  return MaterialPage<void>(
    key: state.pageKey,
    name: state.path,
    child: screen,
  );
}

/// The screens of the app and how to reach them. [initialLocation] is only
/// changed by the tool that takes the store screenshots.
GoRouter buildRouter({String initialLocation = Paths.splash}) {
  return GoRouter(
    initialLocation: initialLocation,
    observers: [BackgroundNavigatorObserver()],
    redirect: (BuildContext context, GoRouterState state) {
      if (!AppStart.done && state.matchedLocation != Paths.splash) {
        return Paths.splash;
      }
      return null;
    },
    // An address that names no screen, typed by hand or from an old link.
    errorPageBuilder: (BuildContext context, GoRouterState state) =>
        _page(state, const HomeScreen()),
    routes: [
      _screen(Paths.splash, const SplashScreen()),
      _screen(Paths.home, const HomeScreen()),
      _screen(Paths.rules, const GameRulesScreen()),
      _screen(Paths.players, const TeamSelectorScreen()),
      _screen(Paths.setup, const GameSetupScreen()),
      _screen(Paths.turn, const GameStartScreen(), inGame: true),
      _screen(Paths.word, const GameProgressScreen(), inGame: true),
      _screen(Paths.result, const GameResultScreen(), inGame: true),
      _screen(Paths.over, const GameOverScreen(), inGame: true),
    ],
  );
}
