import 'package:dartz/dartz.dart';
import '../entities/session.dart';

abstract class SessionsRepository {
  Future<Either<String, List<Session>>> getSessions({required String playerUid});

}
