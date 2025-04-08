import 'package:dartz/dartz.dart';
import '../../../analytics/domain/entities/performance.dart';
import '../../domain/entities/player.dart';
import '../../domain/repositories/player_repository.dart';
import '../data_sources/player_api_service.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final PlayerApiService apiService;

  PlayerRepositoryImpl({required this.apiService});

  @override
  Future<Either<String, List<Player>>> getPlayers(String coachUid) {
    return apiService.fetchPlayers(coachUid);
  }

  @override
  Future<Either<String, Map<String, List<Performance>>>> getPlayersPerformance(List<String> playerUids) {
    return apiService.fetchPlayersPerformance(playerUids);
  }
}
