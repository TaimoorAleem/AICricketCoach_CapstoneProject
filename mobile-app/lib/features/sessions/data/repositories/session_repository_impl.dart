import 'package:dartz/dartz.dart';
import '../../domain/repositories/session_repository.dart';
import '../models/session_model.dart';
import '../../domain/entities/session.dart';
import '../services/sessions_api_service.dart';

class SessionsRepositoryImpl implements SessionsRepository {
  final SessionsApiService apiService;

  SessionsRepositoryImpl({required this.apiService});

  @override
  Future<Either<String, List<Session>>> getSessions({required String playerUid}) async {
    final result = await apiService.fetchSessions(playerUid);

    return result.fold(
          (error) => Left(error),
          (data) {
        try {
          final sessions = (data['sessions'] as List)
              .map((json) => SessionModel.fromJson(json).toEntity())
              .toList();
          return Right(sessions);
        } catch (e) {
          return Left('Failed to parse session data: $e');
        }
      },
    );
  }
}
