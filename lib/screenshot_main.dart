// Entry point used only to take the store screenshots: it opens the game
// directly on one screen, with players and a game already under way.
//
//   flutter build web -t lib/screenshot_main.dart
//   node tool/store_screenshots.mjs
//
// The screen and the language are chosen with the `shot` and `lang` query
// parameters of the page.
import 'package:complicity_game/main.dart';
import 'package:complicity_game/models/game_mode.dart';
import 'package:complicity_game/models/player_model.dart';
import 'package:complicity_game/services/game_service.dart';
import 'package:complicity_game/services/player_manager_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

void main() {
  final String shot = Uri.base.queryParameters['shot'] ?? 'home';
  final String lang = Uri.base.queryParameters['lang'] ?? 'en';

  final PlayerManagerService players = PlayerManagerService();
  const Map<Team, List<String>> names = {
    Team.yellow: ['Giulia', 'Marco', 'Sara'],
    Team.green: ['Luca', 'Anna', 'Paolo'],
  };
  names.forEach((Team team, List<String> teamNames) {
    for (final String name in teamNames) {
      players.insertPlayer(PlayerModel(key: null, name: name, team: team));
    }
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: players),
        ChangeNotifierProvider(
          create: (context) => GameService(context, languageCode: lang),
          lazy: false,
        ),
      ],
      child: ComplicityGame(
        initialRoute: '/',
        navigatorKey: _navigator,
        locale: Locale(lang),
      ),
    ),
  );

  // Once the word lists are loaded, set the scene and open the screen.
  Future<void>.delayed(const Duration(milliseconds: 1500), () => _open(shot));

  // Once the screen has settled, all but stop the animations: the picture is
  // then the same whenever it is taken, countdown included.
  Future<void>.delayed(
    const Duration(milliseconds: 3600),
    () => timeDilation = 100000.0,
  );
}

void _play(GameService game, List<Team?> rounds) {
  for (final Team? team in rounds) {
    game.state.resolve(team);
    game.state.nextTurn();
  }
}

void _open(String shot) {
  final NavigatorState navigator = _navigator.currentState!;
  final GameService game = navigator.context.read<GameService>();

  switch (shot) {
    case 'players':
      navigator.pushNamed('/team_selector');
    case 'setup':
      navigator.pushNamed('/game/setup');
    case 'turn':
      game.configure(mode: GameMode.classic, targetScore: 5);
      game.start();
      _play(game, [Team.green, Team.yellow, Team.green]);
      navigator.pushNamed('/game/start');
    case 'word':
      game.configure(mode: GameMode.classic, targetScore: 5);
      game.start();
      _play(game, [Team.green, Team.yellow, Team.green]);
      navigator.pushNamed('/game/progress');
    case 'result':
      game.configure(mode: GameMode.dares, targetScore: 5);
      game.start();
      _play(game, [Team.green, Team.yellow]);
      final Team clueTeam = game.state.getCurrentPlayer().team;
      game.state.resolve(
        Team.values.firstWhere((Team team) => team != clueTeam),
      );
      navigator.pushNamed('/game/result');
    case 'over':
      game.configure(mode: GameMode.classic, targetScore: 3);
      game.start();
      _play(game, [Team.green, Team.yellow, Team.green]);
      game.state.resolve(Team.green);
      navigator.pushNamed('/game/over');
  }
}
