import 'package:complicity_game/constants/theme.dart';
import 'package:complicity_game/routes.dart';
import 'package:complicity_game/services/player_manager_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerManagerService()),
      ],
      child: const ComplicityGame(),
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
}

class ComplicityGame extends StatelessWidget {
  const ComplicityGame({super.key});

  // This widget is the root of your application.
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
            TargetPlatform.android: NoTransitionPageTransitionsBuilder(),
            TargetPlatform.iOS: NoTransitionPageTransitionsBuilder(),
          },
        ),
      ),
      routes: routes,
    );
  }
}

class NoTransitionPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child; // Ritorna direttamente il widget child, evitando qualsiasi animazione
  }
}
