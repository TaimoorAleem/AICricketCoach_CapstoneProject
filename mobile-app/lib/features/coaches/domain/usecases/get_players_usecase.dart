import 'package:dartz/dartz.dart';
import '../entities/player.dart';
import '../repositories/player_repository.dart';

class GetPlayersUseCase {
  final PlayerRepository repository;

  GetPlayersUseCase({required this.repository});

  Future<Either<String, List<Player>>> call(String coachUid) async {
    return await repository.getPlayers(coachUid);
  }
}
