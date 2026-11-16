import 'dart:convert';

import 'package:complicity_game/models/player_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerManagerService with ChangeNotifier, DiagnosticableTreeMixin {
  final List<PlayerModel> _players = [];

  int lastKey = -1;

  static const String _storageKey = 'players';

  /// Set once [restore] has run: until then nothing is written, so a list
  /// that has not been read yet is never overwritten.
  SharedPreferences? _storage;

  /// Brings back the players of the last time the game was open.
  Future<void> restore() async {
    try {
      final SharedPreferences storage = await SharedPreferences.getInstance();
      final String? saved = storage.getString(_storageKey);

      if (saved != null && _players.isEmpty) {
        for (final dynamic entry in jsonDecode(saved) as List<dynamic>) {
          final String name = (entry['name'] as String?) ?? '';
          final Team team = Team.values.firstWhere(
            (Team team) => team.name == entry['team'],
            orElse: () => Team.green,
          );

          if (name.isNotEmpty) {
            _players.add(PlayerModel(key: ++lastKey, name: name, team: team));
          }
        }
      }

      _storage = storage;
      notifyListeners();
    } catch (_) {
      // Without storage the game still works, it only forgets the names.
    }
  }

  void _save() {
    _storage?.setString(
      _storageKey,
      jsonEncode([
        for (final PlayerModel player in _players)
          {'name': player.name, 'team': player.team.name},
      ]),
    );
  }

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
      _save();

      return _players.last.copy();
    }

    int playerIndex = replacePlayer(player);

    return playerIndex != -1 ? _players[playerIndex].copy() : null;
  }

  PlayerModel? removeLastPlayer() {
    if (_players.isEmpty) {
      return null;
    }

    final PlayerModel removed = _players.removeLast();
    _save();

    return removed;
  }

  PlayerModel? removePlayerByKey(dynamic key) {
    int index = _players.indexWhere(
      (PlayerModel player) => player.key == key,
    );

    if (index == -1) {
      return null;
    }

    final PlayerModel removed = _players.removeAt(index);
    _save();

    return removed;
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
      _save();
    }

    return index;
  }

  void clear() {
    _players.clear();
    lastKey = -1;
    _save();
  }

  bool isReadyToPlay() {
    return Team.values
        .map((Team team) => getPlayersByTeam(team).length)
        .every((int teamSize) => teamSize >= 2);
  }
}
