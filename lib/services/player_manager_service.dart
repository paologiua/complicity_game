import 'package:complicity_game/models/player_model.dart';
import 'package:flutter/foundation.dart';

class PlayerManagerService with ChangeNotifier, DiagnosticableTreeMixin {
  List<PlayerModel> _players = [];

  int lastKey = 0;

  List<PlayerModel> getPlayers() {
    return _players;
  }

  PlayerModel? insertPlayer(PlayerModel player) {
    if (player.name == "") {
      return null;
    }

    if (player.key == null) {
      PlayerModel newPlayer = PlayerModel(
        key: lastKey++,
        name: player.name,
        team: player.team,
      );
      _players.add(newPlayer);

      return newPlayer;
    }

    replacePlayerByKey(player);
    
    return player;
  }

  void removeLastPlayer() {
    _players.removeLast();
  }

  void removePlayerByKey(dynamic key) {
    _players.removeWhere((PlayerModel player) => player.key == key);
  }

  void replacePlayerByKey(PlayerModel player) {
    int index =
        _players.indexWhere((PlayerModel item) => item.key == player.key);
    _players[index] = PlayerModel(
      key: player.key,
      name: player.name,
      team: player.team,
    );
  }

  List<PlayerModel> getPlayersByTeam(Team team) {
    return _players.where((PlayerModel player) => player.team == team).toList();
  }

  void clear() {
    _players = [];
    lastKey = 0;
  }
}
