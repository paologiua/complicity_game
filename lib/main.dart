import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/routes.dart';
import 'package:complicity_game/services/game_service.dart';
import 'package:complicity_game/services/player_manager_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:complicity_game/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PlayerManagerService(),
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

  //Setting SysemUIOverlay
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  //Setting SystmeUIMode
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
}

class ComplicityGame extends StatelessWidget {
  const ComplicityGame({super.key});

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
      initialRoute: '/splash',
    );
  }
}

/// Fades and slightly grows the incoming screen. The shared pills and
/// buttons still fly between screens through their [Hero] widgets.
class PlayfulTransitionsBuilder extends PageTransitionsBuilder {
  const PlayfulTransitionsBuilder();

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

    final Animation<double> curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.94, end: 1.0).animate(curved),
        child: child,
      ),
    );
  }
}
