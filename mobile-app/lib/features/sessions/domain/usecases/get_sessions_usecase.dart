import 'package:dartz/dartz.dart';
import '../../../../resources/usecase.dart';
import '../entities/session.dart';
import '../repositories/session_repository.dart';

class GetSessionsUseCase extends UseCase<Either<String, List<Session>>, String> {
  final SessionsRepository repository;

  GetSessionsUseCase({required this.repository});

  @override
  Future<Either<String, List<Session>>> call({String? params}) async {
    return await repository.getSessions();
  }
}
