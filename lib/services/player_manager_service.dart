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
      _players.add(player.copyWith(key: lastKey++));

      return _players.last;
    }

    int playerIndex = replacePlayerByKey(player);

    return playerIndex != -1 ? _players[playerIndex] : null;
  }

  void removeLastPlayer() {
    _players.removeLast();
  }

  void removePlayerByKey(dynamic key) {
    _players.removeWhere((PlayerModel player) => player.key == key);
  }

  int replacePlayerByKey(PlayerModel player) {
    int index = _players.indexWhere(
      (PlayerModel item) => item.key == player.key,
    );

    if (index != -1) {
      _players[index] = player.copy();
    }

    return index;
  }

  List<PlayerModel> getPlayersByTeam(Team team) {
    return _players.where((PlayerModel player) => player.team == team).toList();
  }

  void clear() {
    _players = [];
    lastKey = 0;
  }
}
