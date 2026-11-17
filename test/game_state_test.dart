import 'dart:math';

import 'package:complicity_game/models/game_mode.dart';
import 'package:complicity_game/models/player_model.dart';
import 'package:complicity_game/services/game_service.dart';
import 'package:flutter_test/flutter_test.dart';

List<PlayerModel> buildPlayers() {
  return [
    PlayerModel(key: 0, name: 'Anna', team: Team.green),
    PlayerModel(key: 1, name: 'Bruno', team: Team.green),
    PlayerModel(key: 2, name: 'Carla', team: Team.yellow),
    PlayerModel(key: 3, name: 'Dario', team: Team.yellow),
  ];
}

GameState buildState({
  GameMode mode = GameMode.classic,
  int targetScore = 3,
  List<String> words = const ['casa', 'mare', 'sole', 'luna'],
  List<String> dares = const [],
}) {
  return GameState(
    players: buildPlayers(),
    words: words,
    mode: mode,
    targetScore: targetScore,
    dares: dares,
    random: Random(42),
  );
}

Team other(Team team) => team == Team.green ? Team.yellow : Team.green;

void main() {
  test('the clue giver scores for their own team without a penalty', () {
    final GameState state = buildState();
    final Team team = state.getCurrentPlayer().team;

    state.resolve(team);

    expect(state.getScore(team), 1);
    expect(state.getScore(other(team)), 0);
    expect(state.lastOutcome!.isStolen, isFalse);
    expect(state.lastOutcome!.isDraw, isFalse);
    expect(state.lastOutcome!.hasPenalty, isFalse);
  });

  test('a word guessed by the opponents is stolen', () {
    final GameState state = buildState();
    final Team team = state.getCurrentPlayer().team;

    state.resolve(other(team));

    expect(state.getScore(other(team)), 1);
    expect(state.lastOutcome!.isStolen, isTrue);
    expect(state.lastOutcome!.hasPenalty, isTrue);
  });

  test('a draw gives no points', () {
    final GameState state = buildState();

    state.resolve(null);

    expect(state.getScore(Team.green), 0);
    expect(state.getScore(Team.yellow), 0);
    expect(state.lastOutcome!.isDraw, isTrue);
    expect(state.lastOutcome!.hasPenalty, isTrue);
  });

  test('resolving twice counts the turn once', () {
    final GameState state = buildState();
    final Team team = state.getCurrentPlayer().team;

    state.resolve(team);
    state.resolve(team);

    expect(state.getScore(team), 1);
  });

  test('the turn only advances with nextTurn', () {
    final GameState state = buildState();
    final PlayerModel first = state.getCurrentPlayer();
    final String firstWord = state.getWord();

    state.resolve(null);
    expect(state.getCurrentPlayer(), same(first));
    expect(state.getWord(), firstWord);

    state.nextTurn();
    expect(state.getCurrentPlayer().team, other(first.team));
    expect(state.getWord(), isNot(firstWord));
  });

  test('the game ends when a team reaches the target score', () {
    final GameState state = buildState(targetScore: 2);

    state.resolve(Team.green);
    expect(state.isOver, isFalse);
    state.nextTurn();

    state.resolve(Team.yellow);
    state.nextTurn();

    state.resolve(Team.green);
    expect(state.isOver, isTrue);
    expect(state.winner, Team.green);
    expect(state.scoreGap, 1);
  });

  test('words are reused once they have all been played', () {
    final GameState state = buildState(
      targetScore: 100,
      words: const ['casa', 'mare'],
    );

    for (int turn = 0; turn < 10; turn++) {
      expect(const ['casa', 'mare'], contains(state.getWord()));
      state.resolve(null);
      state.nextTurn();
    }
  });

  test('the guessers are everyone except the clue giver', () {
    final GameState state = buildState();
    final PlayerModel cluePlayer = state.getCurrentPlayer();

    final List<PlayerModel> guessers = state.getSoothsayers();

    expect(guessers.length, 3);
    expect(guessers, isNot(contains(same(cluePlayer))));
  });

  test('themed words are mixed with the ordinary ones', () {
    const List<String> themed = ['bacio', 'flirt'];
    final GameState state = GameState(
      players: [
        PlayerModel(key: 0, name: 'Anna', team: Team.green),
        PlayerModel(key: 1, name: 'Luca', team: Team.yellow),
      ],
      words: const ['casa', 'mare', 'sole', 'luna'],
      themedWords: themed,
      random: Random(7),
    );

    int themedCount = 0;
    const int turns = 300;
    for (int i = 0; i < turns; i++) {
      if (themed.contains(state.getWord())) themedCount++;
      state.resolve(null);
      state.nextTurn();
    }

    // About one word out of three, never all of them and never none.
    expect(themedCount, inInclusiveRange(70, 130));
  });

  group('dares', () {
    const List<String> dares = ['balla', 'canta'];

    test('a penalty gives the clue giver a dare', () {
      final GameState state = buildState(mode: GameMode.dares, dares: dares);

      state.resolve(null);

      expect(dares, contains(state.lastOutcome!.dare));
    });

    test('a clean point gives no dare', () {
      final GameState state = buildState(mode: GameMode.spicy, dares: dares);

      state.resolve(state.getCurrentPlayer().team);

      expect(state.lastOutcome!.dare, isNull);
    });

    test('the classic mode never gives dares', () {
      final GameState state = buildState(mode: GameMode.classic, dares: dares);

      state.resolve(null);

      expect(state.lastOutcome!.dare, isNull);
    });

    test('the drinking mode draws a rule for a penalty, none at the end', () {
      final GameState state = buildState(
        mode: GameMode.drinking,
        targetScore: 1,
        dares: dares,
      );
      final Team opponents = Team.values.firstWhere(
        (Team team) => team != state.getCurrentPlayer().team,
      );

      state.resolve(opponents);

      expect(dares, contains(state.lastOutcome!.dare));
      expect(state.isOver, isTrue);
      expect(state.finalDare, isNull);
    });

    test('the losing team gets a final dare', () {
      final GameState state = buildState(
        mode: GameMode.dares,
        targetScore: 1,
        dares: dares,
      );
      expect(state.finalDare, isNull);

      state.resolve(Team.green);

      expect(state.isOver, isTrue);
      expect(dares, contains(state.finalDare));
    });
  });
}
