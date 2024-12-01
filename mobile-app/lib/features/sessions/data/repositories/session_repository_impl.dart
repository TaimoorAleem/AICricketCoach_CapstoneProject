import '../../domain/entities/session.dart';
import '../../domain/entities/delivery.dart';
import '../../domain/repositories/session_repository.dart';
import '../data_sources/sessions_remote_data_source.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionsRemoteDataSource remoteDataSource;

  SessionRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<Session>> fetchSessions(String uid) async {
      final remoteSessions = await remoteDataSource.getSessions(uid);
      return remoteSessions.map((model) => model.toDomain()).toList();
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