import 'package:dartz/dartz.dart';
import '../repositories/session_repository.dart';
import '../entities/session.dart';

class GetSessionsUseCase {
  final SessionsRepository repository;

  GetSessionsUseCase({required this.repository});

  Future<Either<String, List<Session>>> call({required String playerUid}) async {
    return await repository.getSessions(playerUid: playerUid);
  }
}
