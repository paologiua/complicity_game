import 'package:complicity_game/models/player_model.dart';
import 'package:complicity_game/services/player_manager_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('players come back the next time the game is opened', () async {
    SharedPreferences.setMockInitialValues({});

    final PlayerManagerService first = PlayerManagerService();
    await first.restore();
    first.insertPlayer(PlayerModel(key: null, name: 'Anna', team: Team.green));
    first.insertPlayer(PlayerModel(key: null, name: 'Luca', team: Team.yellow));
    first.insertPlayer(PlayerModel(key: null, name: 'Gone', team: Team.yellow));
    first.removeLastPlayer();

    final PlayerManagerService second = PlayerManagerService();
    await second.restore();

    expect(
      second.getPlayers().map((PlayerModel p) => '${p.name}:${p.team.name}'),
      ['Anna:green', 'Luca:yellow'],
    );

    // New players still get keys of their own after a restore.
    final PlayerModel? added = second.insertPlayer(
      PlayerModel(key: null, name: 'Marta', team: Team.green),
    );
    expect(second.getPlayers().map((PlayerModel p) => p.key).toSet().length, 3);
    expect(added?.name, 'Marta');
  });

  test('nothing is written before the saved list has been read', () async {
    SharedPreferences.setMockInitialValues({
      'players': '[{"name":"Anna","team":"green"}]',
    });

    final PlayerManagerService service = PlayerManagerService();
    service.clear();

    final SharedPreferences storage = await SharedPreferences.getInstance();
    expect(storage.getString('players'), contains('Anna'));
  });
}
