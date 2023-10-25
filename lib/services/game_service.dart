import 'dart:io';
import 'dart:math';

import 'package:complicity_game/services/player_manager_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/player_model.dart';

class GameState {
  GameState({
    required List<PlayerModel> players,
    required this.words,
  }) {
    for (Team team in Team.values) {
      _players[team.name] = [];
    }

    for (PlayerModel player in players..shuffle()) {
      _players[player.team.name]?.add(player);
    }

    _turn = (Team.values.toList()..shuffle()).first;
    _word = words.removeAt(Random().nextInt(words.length));
  }

  final Map<String, int> _indexes = {};
  final Map<String, List<PlayerModel>> _players = {};
  final Map<String, int> _scores = {};

  List<String> words;

  late Team _turn;
  late String _word;

  void _next() {
    _turn = Team.values[(Team.values.indexOf(_turn) + 1) % Team.values.length];
    _indexes[_turn.name] =
        ((_indexes[_turn.name] ?? 0) + 1) % (_players[_turn.name] ?? []).length;

    _word = words.removeAt(Random().nextInt(words.length));
  }

  void win(Team team) {
    _scores[team.name] = (_scores[team.name] ?? 0) + 1;

    _next();
  }

  PlayerModel getCurrentPlayer() {
    return (_players[_turn.name] ?? [])[_indexes[_turn.name] ?? 0];
  }

  int getScore(Team team) {
    return _scores[team.name] ?? 0;
  }

  String getWord() {
    return _word;
  }
}

class GameService with ChangeNotifier, DiagnosticableTreeMixin {
  GameService(BuildContext context) {
    _context = context;

    String languageCode = Platform.localeName.split('_')[0];
    rootBundle
        .loadString("assets/data/nouns_$languageCode.csv")
        .then((String rawData) {
      _words = rawData.split("\n");
    });
  }

  late BuildContext _context;

  List<String> _words = [];
  late GameState state;

  void start() {
    PlayerManagerService playerManagerService =
        _context.read<PlayerManagerService>();

    state = GameState(
      players: playerManagerService.getPlayers(),
      words: _words,
    );
  }
}
