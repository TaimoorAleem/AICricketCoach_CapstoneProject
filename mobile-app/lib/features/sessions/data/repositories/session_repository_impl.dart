import '../../domain/entities/session.dart';
import '../../domain/entities/delivery.dart';
import '../../domain/repositories/session_repository.dart';
import '../data_sources/sessions_local_data_source.dart';
import '../data_sources/sessions_remote_data_source.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionsRemoteDataSource remoteDataSource;
  final SessionsLocalDataSource localDataSource;

  SessionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Session>> fetchSessions() async {
    if (await localDataSource.hasCachedSessions()) {
      // Retrieve cached sessions
      final cachedSessions = await localDataSource.getCachedSessions();
      return cachedSessions.map((model) => model.toDomain()).toList();
    } else {
      // Fetch sessions from API and cache them
      final remoteSessions = await remoteDataSource.getSessions();
      await localDataSource.cacheSessions(remoteSessions);
      return remoteSessions.map((model) => model.toDomain()).toList();
    }
  }

  @override
  Future<List<Delivery>> fetchDeliveries(String sessionId) async {
    final remoteDeliveries = await remoteDataSource.getDeliveries(sessionId);
    return remoteDeliveries.map((model) => model.toDomain()).toList();
  }

  @override
  Future<Delivery> fetchDeliveryDetails(String deliveryId) async {
    final remoteDelivery = await remoteDataSource.getDeliveryDetails(deliveryId);
    return remoteDelivery.toDomain();
  }
}