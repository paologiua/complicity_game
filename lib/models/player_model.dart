enum Team { green, yellow }

class PlayerModel {
  PlayerModel({
    required this.key,
    required this.name,
    required this.team,
  });

  final dynamic key;
  String name;
  Team team;
}