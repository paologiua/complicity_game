import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/routes.dart';
import 'package:complicity_game/services/game_service.dart';
import 'package:complicity_game/services/player_manager_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: NoneTransitionsBuilder(),
            TargetPlatform.iOS: NoneTransitionsBuilder(),
            TargetPlatform.linux: NoneTransitionsBuilder(),
            TargetPlatform.macOS: NoneTransitionsBuilder(),
            TargetPlatform.windows: NoneTransitionsBuilder(),
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

class NoneTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Returns the child widget directly, avoiding any animation
    return child;
  }
}
