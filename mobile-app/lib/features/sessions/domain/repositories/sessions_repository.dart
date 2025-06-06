import 'package:dartz/dartz.dart';
import '../entities/session.dart';
import '../entities/delivery.dart';

abstract class SessionsRepository {
  Future<Either<String, List<Session>>> getSessions({required String playerUid});
  Future<Either<String, void>> addFeedback({
    required String playerId,
    required String sessionId,
    required String deliveryId,
    required double battingRating,
    required String feedback,
  });
  Future<Either<String, void>> addDelivery({
    required String playerId,
    required String sessionId,
    required Delivery delivery,
  });
}
