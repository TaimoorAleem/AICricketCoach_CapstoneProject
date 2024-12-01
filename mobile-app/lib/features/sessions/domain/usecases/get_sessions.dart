import '../entities/session.dart';
import '../repositories/session_repository.dart';

class GetSessions {
  final SessionRepository repository;

  GetSessions(this.repository);

  Future<List<Session>> execute(String uid) async {
    return await repository.fetchSessions(uid);
  }
}