import '../entities/session.dart';
import '../repositories/session_repository.dart';

class GetSessions {
  final SessionRepository repository;

  GetSessions(this.repository);

  Future<List<Session>> execute() async {
    return await repository.fetchSessions();
  }
}