import 'package:complicity_game/services/player_manager_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/player_model.dart';

class GameState {
  GameState({
    required this.player,
    required this.word,
  });

  PlayerModel player;
  String word;
}

class GameService with ChangeNotifier, DiagnosticableTreeMixin {
  final List<PlayerModel> _greenPlayers = [];
  final List<PlayerModel> _yellowPlayers = [];

  int _greenScore = 0;
  int _yellowScore = 0;

  Team? _turn;

  void start(BuildContext context) {
    reset();

    PlayerManagerService playerManagerService =
        context.read<PlayerManagerService>();

    _greenPlayers.addAll(playerManagerService.getPlayersByTeam(Team.green));
    _yellowPlayers.addAll(playerManagerService.getPlayersByTeam(Team.yellow));

    _turn = (Team.values.toList()..shuffle()).first;
  }

  GameState next() {
    PlayerModel player = _turn == Team.green
        ? (_greenPlayers..shuffle()).first
        : (_yellowPlayers..shuffle()).first;

    return GameState(
      player: player,
      word: "",
    );
  }

  void toggleTurn() {
    if (_turn == Team.green) {
      _turn = Team.yellow;
    } else {
      _turn = Team.green;
    }
  }

  void win(Team team) {
    if (team == Team.green) {
      _greenScore++;
    } else {
      _yellowScore++;
    }

    toggleTurn();
  }

  int getScore(Team team) {
    return team == Team.green ? _greenScore : _yellowScore;
  }

  void reset() {
    _greenPlayers.clear();
    _yellowPlayers.clear();
    _turn = null;
    _greenScore = 0;
    _yellowScore = 0;
  }
}
