import '../../data/repositories/session_repository_impl.dart';
import '../entities/session.dart';
import 'package:dartz/dartz.dart';

class GetSessionsUseCase {
  final SessionRepositoryImpl repository;

  GetSessionsUseCase(this.repository);

  Future<Either<String, List<Session>>> execute(String uid) {
    return repository.fetchSessions(uid);
  }
}