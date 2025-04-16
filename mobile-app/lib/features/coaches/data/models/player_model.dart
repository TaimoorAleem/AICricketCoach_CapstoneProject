import '../../domain/entities/player_entity.dart';

class PlayerModel extends PlayerEntity {
  PlayerModel({
    required String uid,
    required String firstName,
    required String lastName,
    required String email,
    required String role,
    String? teamName,
    String? age,
    String? city,
    String? country,
    String? description,
    String? pfpUrl,
  }) : super(
    uid: uid,
    firstName: firstName,
    lastName: lastName,
    email: email,
    role: role,
    teamName: teamName,
    age: age,
    city: city,
    country: country,
    description: description,
    pfpUrl: pfpUrl,
  );

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    return PlayerModel(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      teamName: map['teamName'],
      age: map['age']?.toString(),
      city: map['city'],
      country: map['country'],
      description: map['description'],
      pfpUrl: map['pfpUrl'],
    );
  }

  static List<PlayerModel> fromResponseMap(Map<String, dynamic> playersMap) {
    return playersMap.entries
        .map((entry) => PlayerModel.fromMap(entry.value))
        .toList();
  }
}
