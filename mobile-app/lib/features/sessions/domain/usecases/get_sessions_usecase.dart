import 'package:dartz/dartz.dart';
import '../entities/session.dart';
import '../repositories/sessions_repository.dart';

class GetSessionsUseCase {
  final SessionsRepository repository;

  GetSessionsUseCase(this.repository);

  Future<Either<String, List<Session>>> call({required String playerUid}) {
    return repository.getSessions(playerUid: playerUid);
  }
}
