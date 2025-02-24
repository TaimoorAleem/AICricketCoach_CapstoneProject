import 'package:dartz/dartz.dart';
import '../../../analytics/domain/entities/performance.dart';
import '../entities/player.dart';

abstract class PlayerRepository {
  Future<Either<String, List<Player>>> getPlayers(String coachUid);
  Future<Either<String, Map<String, List<Performance>>>> getPlayersPerformance(List<String> playerUids);
}
