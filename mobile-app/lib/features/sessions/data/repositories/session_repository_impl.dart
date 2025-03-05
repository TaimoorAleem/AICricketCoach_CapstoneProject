import 'package:dartz/dartz.dart';
import '../../domain/repositories/session_repository.dart';
import '../data_sources/sessions_api_service.dart';
import '../../domain/entities/session.dart';
import '../models/session_model.dart';

class SessionsRepositoryImpl implements SessionsRepository {
  final SessionApiService apiService;

  SessionsRepositoryImpl({required this.apiService});

  @override
  Future<Either<String, List<Session>>> getSessions({required String playerUid}) async {
    try {
      final result = await apiService.fetchSessions(playerUid);
      final sessions = (result['sessions'] as List)
          .map((json) => SessionModel.fromJson(json).toEntity())
          .toList();
      return Right(sessions);
    } catch (e) {
      return Left(e.toString());
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
      return Left(e.toString());
    }
  }
}
