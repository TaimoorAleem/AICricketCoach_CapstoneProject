import 'package:dartz/dartz.dart';
import '../../../analytics/domain/entities/performance.dart';
import '../../domain/entities/player.dart';
import '../../domain/repositories/player_repository.dart';
import '../data_sources/player_api_service.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final PlayerApiService apiService;

  PlayerRepositoryImpl({required this.apiService});

  @override
  Future<Either<String, List<Player>>> getPlayers(String coachUid) async {
    try {
      final players = await apiService.fetchPlayers(coachUid);
      return Right(players);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Map<String, List<Performance>>>> getPlayersPerformance(List<String> playerUids) async {
    try {
      final performances = await apiService.fetchPlayersPerformance(playerUids);
      return Right(performances);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
