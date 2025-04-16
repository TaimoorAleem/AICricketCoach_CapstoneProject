import '../entities/player_entity.dart';
import '../repositories/player_repository.dart';

class GetPlayersUseCase {
  final PlayerRepository repository;

  GetPlayersUseCase({required this.repository});

  Future<List<PlayerEntity>> call(String coachUid) {
    return repository.getPlayers(coachUid);
  }
}