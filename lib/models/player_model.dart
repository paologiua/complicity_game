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

  PlayerModel copy() {
    return PlayerModel(
      key: key,
      name: name,
      team: team,
    );
  }

  PlayerModel copyWith({
    dynamic key,
    String? name,
    Team? team,
  }) {
    return PlayerModel(
      key: key ?? this.key,
      name: name ?? this.name,
      team: team ?? this.team,
    );
  }
}
