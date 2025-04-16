import '../entities/player_entity.dart';

abstract class PlayerRepository {
  Future<List<PlayerEntity>> getPlayers(String coachUid);
}
