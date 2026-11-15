import 'dart:math';

import 'package:complicity_game/constants/options.dart';
import 'package:complicity_game/services/player_manager_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/game_mode.dart';
import '../models/player_model.dart';

/// What happened in the turn that was just played.
class RoundOutcome {
  const RoundOutcome({
    required this.cluePlayer,
    required this.word,
    this.scoringTeam,
    this.dare,
  });

  /// The player who was giving the clues.
  final PlayerModel cluePlayer;
  final String word;

  /// The team that guessed the word, or null when nobody did.
  final Team? scoringTeam;

  /// The dare picked for the clue giver, if the mode has dares.
  final String? dare;

  bool get isDraw => scoringTeam == null;

  /// The opposing team guessed the word instead of the clue giver's team.
  bool get isStolen => scoringTeam != null && scoringTeam != cluePlayer.team;

  bool get hasPenalty => isDraw || isStolen;
}

class GameState {
  GameState({
    required List<PlayerModel> players,
    required List<String> words,
    this.mode = GameMode.classic,
    this.targetScore = OptionsConstants.defaultTargetScore,
    List<String> dares = const [],
    Random? random,
  })  : _random = random ?? Random(),
        _allWords = words.where((String word) => word.isNotEmpty).toList(),
        _allDares = dares.where((String dare) => dare.isNotEmpty).toList() {
    for (Team team in Team.values) {
      _players[team] = [];
    }

    for (PlayerModel player in List.of(players)..shuffle(_random)) {
      _players[player.team]!.add(player);
    }

    _turn = Team.values[_random.nextInt(Team.values.length)];
    _word = _drawWord();
  }

  final GameMode mode;
  final int targetScore;

  final Random _random;
  final List<String> _allWords;
  final List<String> _allDares;
  List<String> _wordPool = [];
  List<String> _darePool = [];

  final Map<Team, int> _indexes = {};
  final Map<Team, List<PlayerModel>> _players = {};
  final Map<Team, int> _scores = {};

  late Team _turn;
  late String _word;

  RoundOutcome? _lastOutcome;
  String? _finalDare;
  bool _resolved = false;

  /// Picks a random word that has not been used yet. When every word has
  /// been played the pool is refilled, so a long game never runs dry.
  String _drawWord() {
    if (_wordPool.isEmpty) {
      _wordPool = List.of(_allWords);
    }
    if (_wordPool.isEmpty) {
      return '?';
    }

    return _wordPool.removeAt(_random.nextInt(_wordPool.length));
  }

  String? _drawDare() {
    if (_darePool.isEmpty) {
      _darePool = List.of(_allDares);
    }
    if (_darePool.isEmpty) {
      return null;
    }

    return _darePool.removeAt(_random.nextInt(_darePool.length));
  }

  /// Closes the current turn: [team] scores a point, or nobody does when it
  /// is null. The turn does not advance until [nextTurn] is called.
  void resolve(Team? team) {
    if (_resolved) {
      return;
    }
    _resolved = true;

    final PlayerModel cluePlayer = getCurrentPlayer();
    final bool hasPenalty = team == null || team != cluePlayer.team;

    if (team != null) {
      _scores[team] = getScore(team) + 1;
    }

    _lastOutcome = RoundOutcome(
      cluePlayer: cluePlayer,
      word: _word,
      scoringTeam: team,
      dare: mode.hasDares && hasPenalty ? _drawDare() : null,
    );

    if (isOver && mode.hasDares) {
      _finalDare = _drawDare();
    }
  }

  /// Moves to the next team, player and word.
  void nextTurn() {
    if (!_resolved || isOver) {
      return;
    }
    _resolved = false;

    _turn = Team.values[(Team.values.indexOf(_turn) + 1) % Team.values.length];

    final int teamSize = _players[_turn]!.length;
    if (teamSize > 0) {
      _indexes[_turn] = ((_indexes[_turn] ?? 0) + 1) % teamSize;
    }

    _word = _drawWord();
  }

  RoundOutcome? get lastOutcome => _lastOutcome;

  /// The dare for the losing team, available once the game is over.
  String? get finalDare => _finalDare;

  Team? get winner {
    for (Team team in Team.values) {
      if (getScore(team) >= targetScore) {
        return team;
      }
    }

    return null;
  }

  bool get isOver => winner != null;

  /// Points between the winner and the loser, 0 while the game is running.
  int get scoreGap {
    final Team? winningTeam = winner;
    if (winningTeam == null) {
      return 0;
    }

    return getScore(winningTeam) - getScore(winningTeam.opponentTeam);
  }

  PlayerModel getCurrentPlayer() {
    return _players[_turn]![_indexes[_turn] ?? 0];
  }

  List<PlayerModel> getSoothsayers() {
    final PlayerModel currentPlayer = getCurrentPlayer();

    return _players.values
        .expand((List<PlayerModel> team) => team)
        .where((PlayerModel player) => !identical(player, currentPlayer))
        .toList();
  }

  int getScore(Team team) {
    return _scores[team] ?? 0;
  }

  String getWord() {
    return _word;
  }
}

extension on Team {
  Team get opponentTeam => this == Team.green ? Team.yellow : Team.green;
}

class GameService with ChangeNotifier, DiagnosticableTreeMixin {
  GameService(BuildContext context) : _context = context {
    _load();
  }

  final BuildContext _context;

  List<String> _words = [];
  final Map<GameMode, List<String>> _dares = {};

  GameMode mode = GameMode.classic;
  int targetScore = OptionsConstants.defaultTargetScore;

  late GameState state;

  Future<void> _load() async {
    final String languageCode =
        PlatformDispatcher.instance.locale.languageCode;

    _words = await _loadLines('assets/data/nouns', languageCode, 'csv');
    _dares[GameMode.dares] =
        await _loadLines('assets/data/dares_dares', languageCode, 'txt');
    _dares[GameMode.spicy] =
        await _loadLines('assets/data/dares_spicy', languageCode, 'txt');
  }

  /// Loads one entry per line, falling back to English when the device
  /// language has no file.
  Future<List<String>> _loadLines(
    String prefix,
    String languageCode,
    String extension,
  ) async {
    for (String code in {languageCode, 'en'}) {
      try {
        final String rawData =
            await rootBundle.loadString('${prefix}_$code.$extension');

        return rawData
            .split('\n')
            .map((String line) => line.trim())
            .where((String line) => line.isNotEmpty)
            .toList();
      } catch (_) {
        // No file for this language: try the next one.
      }
    }

    return [];
  }

  void configure({required GameMode mode, required int targetScore}) {
    this.mode = mode;
    this.targetScore = targetScore;
    notifyListeners();
  }

  void start() {
    PlayerManagerService playerManagerService =
        _context.read<PlayerManagerService>();

    state = GameState(
      players: playerManagerService.getPlayers(),
      words: _words,
      mode: mode,
      targetScore: targetScore,
      dares: _dares[mode] ?? const [],
    );
    notifyListeners();
  }

  /// Starts a new game with the same teams, mode and target score.
  void restart() => start();
}
