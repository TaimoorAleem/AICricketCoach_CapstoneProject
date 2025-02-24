import 'package:dartz/dartz.dart';
import '../../domain/repositories/session_repository.dart';
import '../models/session_model.dart';
import '../../domain/entities/session.dart';
import '../data_sources/sessions_api_service.dart';

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
}
