import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/routes.dart';
import 'package:complicity_game/services/game_service.dart';
import 'package:complicity_game/services/player_manager_service.dart';
import 'package:complicity_game/models/game_mode.dart';
import 'package:complicity_game/widgets/background_motion.dart';
import 'package:complicity_game/widgets/playful_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:complicity_game/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PlayerManagerService()..restore(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => GameService(context),
          lazy: false,
        ),
      ],
      child: const ComplicityGame(),
    ),
  );

  //Setting PreferredOrientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

/// The cream background runs under transparent system bars, with dark icons
/// on top. Android would otherwise lay a grey scrim or a black bar over them.
/// It is applied through an [AnnotatedRegion] over the whole app, so Flutter
/// keeps both bars in this style on every frame.
const SystemUiOverlayStyle _systemBars = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
  systemStatusBarContrastEnforced: false,
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarDividerColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.dark,
  systemNavigationBarContrastEnforced: false,
);

class ComplicityGame extends StatelessWidget {
  const ComplicityGame({
    super.key,
    this.initialRoute = '/splash',
    this.navigatorKey,
    this.locale,
  });

  /// Where the app opens. Only the tool that takes the store screenshots
  /// starts anywhere else than the splash screen.
  final String initialRoute;
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Language of the app; the one of the device when null.
  final Locale? locale;

  // This widget is the root of application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complicity Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Poppins",
        textTheme: const TextTheme(
          bodyLarge: ThemeConstants.defaultTextStyle,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: PlayfulTransitionsBuilder(),
            TargetPlatform.iOS: PlayfulTransitionsBuilder(),
            TargetPlatform.linux: PlayfulTransitionsBuilder(),
            TargetPlatform.macOS: PlayfulTransitionsBuilder(),
            TargetPlatform.windows: PlayfulTransitionsBuilder(),
          },
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routes: routes,
      navigatorObservers: [BackgroundNavigatorObserver()],
      // One background behind every screen: pages slide over it instead of
      // each bringing its own.
      builder: (BuildContext context, Widget? child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: _systemBars,
          child: Stack(
            children: [
              Positioned.fill(
                child: ValueListenableBuilder<GameMode>(
                  valueListenable: BackgroundMotion.mode,
                  builder: (BuildContext context, GameMode mode, _) {
                    return PlayfulBackground(mode: mode);
                  },
                ),
              ),
              if (child != null) child,
            ],
          ),
        );
      },
      initialRoute: initialRoute,
      navigatorKey: navigatorKey,
      locale: locale,
    );
  }
}

/// Screens are transparent over the shared background, so the outgoing one
/// slides away and fades while the incoming one springs in from the side the
/// background is being swept from. Shared pills and buttons still fly between
/// screens through their [Hero] widgets.
class PlayfulTransitionsBuilder extends PageTransitionsBuilder {
  const PlayfulTransitionsBuilder();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 520);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 420);

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (MediaQuery.of(context).disableAnimations) {
      return child;
    }

    final Animation<double> enter = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
      reverseCurve: const Interval(0.3, 1.0, curve: Curves.easeInOutCubic),
    );
    final Animation<double> enterFade = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    );
    final Animation<double> leave = CurvedAnimation(
      parent: secondaryAnimation,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInCubic),
      // Going back, the revealed screen must slow down into place: a curve
      // that is flat near zero does that when the animation runs in reverse.
      reverseCurve: const Interval(0.0, 0.85, curve: Curves.easeInOutCubic),
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.25, 0.0),
      ).animate(leave),
      child: FadeTransition(
        opacity: ReverseAnimation(leave),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.3, 0.0),
            end: Offset.zero,
          ).animate(enter),
          child: FadeTransition(opacity: enterFade, child: child),
        ),
      ),
    );
  }
}
