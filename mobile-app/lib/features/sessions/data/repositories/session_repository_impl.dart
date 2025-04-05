import 'package:dartz/dartz.dart';
import '../../domain/entities/session.dart';
import '../../domain/entities/delivery.dart';
import '../../domain/repositories/session_repository.dart';
import '../data_sources/session_api_service.dart';
import '../models/session_model.dart';

class SessionsRepositoryImpl implements SessionsRepository {
  final SessionApiService apiService;

  SessionsRepositoryImpl({required this.apiService});

  @override
  Future<Either<String, List<Session>>> getSessions({required String playerUid}) async {
    try {
      final result = await apiService.fetchSessions(playerUid);
      print("📦 Raw API result: $result");

      final sessionsJson = result['sessions'];
      if (sessionsJson == null || sessionsJson is! List) {
        return const Right([]); // Return empty list if sessions are missing or malformed
      }

      final sessions = sessionsJson
          .map<Session>((json) => SessionModel.fromJson(json).toEntity())
          .toList();

      return Right(sessions);
    } catch (e, stack) {
      print("❌ Error fetching sessions: $e\n$stack");
      return Left('Failed to fetch sessions: $e');
    }
  }

  @override
  Future<Either<String, void>> addFeedback({
    required String playerId,
    required String sessionId,
    required String deliveryId,
    required double battingRating,
    required String feedback,
  }) async {
    try {
      await apiService.addFeedback(
        playerId: playerId,
        sessionId: sessionId,
        deliveryId: deliveryId,
        battingRating: battingRating,
        feedback: feedback,
      );
      return const Right(null);
    } catch (e) {
      return Left('Failed to submit feedback: $e');
    }
  }

  @override
  Future<Either<String, void>> addDelivery({
    required String playerId,
    required String sessionId,
    required Delivery delivery,
  }) async {
    try {
      await apiService.addDelivery(
        playerId: playerId,
        sessionId: sessionId,
        delivery: delivery,
      );
      return const Right(null);
    } catch (e) {
      return Left('Failed to add delivery: $e');
    }
  }
}
