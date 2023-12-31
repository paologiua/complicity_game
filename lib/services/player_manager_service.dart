import 'package:complicity_game/models/player_model.dart';
import 'package:flutter/foundation.dart';

class PlayerManagerService with ChangeNotifier, DiagnosticableTreeMixin {
  final List<PlayerModel> _players = [];

  int lastKey = -1;

  List<PlayerModel> getPlayers() {
    return _players.map((PlayerModel player) => player.copy()).toList();
  }

  List<PlayerModel> getPlayersByTeam(Team team) {
    return getPlayers()
        .where((PlayerModel player) => player.team == team)
        .toList();
  }

  PlayerModel? insertPlayer(PlayerModel player) {
    if (player.name.isEmpty) {
      return null;
    }

    if (player.key == null) {
      _players.add(player.copyWith(key: ++lastKey));

      return _players.last.copy();
    }

    int playerIndex = replacePlayer(player);

    return playerIndex != -1 ? _players[playerIndex].copy() : null;
  }

  PlayerModel? removeLastPlayer() {
    if (_players.isEmpty) {
      return null;
    }

    return _players.removeLast();
  }

  PlayerModel? removePlayerByKey(dynamic key) {
    int index = _players.indexWhere(
      (PlayerModel player) => player.key == key,
    );

    if (index == -1) {
      return null;
    }

    return _players.removeAt(index);
  }

  PlayerModel? removePlayer(PlayerModel player) {
    return removePlayerByKey(player.key);
  }

  int replacePlayer(PlayerModel player) {
    int index = _players.indexWhere(
      (PlayerModel item) => item.key == player.key,
    );

    if (index != -1) {
      _players[index] = player.copy();
    }

    return index;
  }

  void clear() {
    _players.clear();
    lastKey = -1;
  }

  bool isReadyToPlay() {
    return Team.values
        .map((Team team) => getPlayersByTeam(team).length)
        .every((int teamSize) => teamSize >= 2);
  }
}
