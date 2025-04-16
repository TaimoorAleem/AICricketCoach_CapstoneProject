import 'package:dartz/dartz.dart';
import '../../domain/entities/session.dart';
import '../../domain/entities/delivery.dart';
import '../../domain/repositories/sessions_repository.dart';
import '../data_sources/session_api_service.dart';
import '../models/session_model.dart';

class SessionsRepositoryImpl implements SessionsRepository {
  final SessionsApiService apiService;

  SessionsRepositoryImpl({required this.apiService});

  @override
  Future<Either<String, List<Session>>> getSessions({required String playerUid}) async {
    final result = await apiService.fetchSessions(playerUid);

    return result.fold(
          (failure) => Left(failure),
          (data) {
        try {
          final sessionsJson = data['sessions'];
          if (sessionsJson == null || sessionsJson is! List) {
            return const Right([]);
          }

          final sessions = (sessionsJson as List<dynamic>)
              .map<Session>((json) => SessionModel.fromJson(json as Map<String, dynamic>).toEntity())
              .toList();

          return Right(sessions);
        } catch (e) {
          return Left('Failed to parse sessions: $e');
        }
      },
    );
  }

  @override
  Future<Either<String, void>> addFeedback({
    required String playerId,
    required String sessionId,
    required String deliveryId,
    required double executionRating,
    required String feedback,
  }) async {
    return await apiService.addFeedback(
      playerId: playerId,
      sessionId: sessionId,
      deliveryId: deliveryId,
      executionRating: executionRating,
      feedback: feedback,
    );
  }


  @override
  Future<Either<String, void>> addDelivery({
    required String playerId,
    required String sessionId,
    required Delivery delivery,
  }) async {
    return await apiService.addDelivery(
      playerId: playerId,
      sessionId: sessionId,
      delivery: delivery,
    );
  }
}
