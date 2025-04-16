import '../../domain/entities/player_entity.dart';
import '../../domain/repositories/player_repository.dart';
import '../data_sources/player_api_service.dart';
import '../models/player_model.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final PlayerApiService apiService;

  PlayerRepositoryImpl({required this.apiService});

  @override
  Future<List<PlayerEntity>> getPlayers(String coachUid) async {
    final playersMap = await apiService.fetchPlayers(coachUid);
    return PlayerModel.fromResponseMap(playersMap);
  }
}
