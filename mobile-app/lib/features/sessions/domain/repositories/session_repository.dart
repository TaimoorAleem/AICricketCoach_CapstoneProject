import '../entities/session.dart';
import '../entities/delivery.dart';

abstract class SessionRepository {
  Future<List<Session>> fetchSessions(String uid);
  Future<List<Delivery>> fetchDeliveries(String sessionId);
  Future<Delivery> fetchDeliveryDetails(String deliveryId);
}