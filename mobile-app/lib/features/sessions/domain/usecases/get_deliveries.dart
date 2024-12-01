import '../entities/delivery.dart';
import '../repositories/session_repository.dart';

class GetDeliveries {
  final SessionRepository repository;

  GetDeliveries(this.repository);

  Future<List<Delivery>> call(String sessionId) async {
    return await repository.fetchDeliveries(sessionId);
  }
}