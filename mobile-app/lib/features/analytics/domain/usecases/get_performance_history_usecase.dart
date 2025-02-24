import 'package:dartz/dartz.dart';
import '../entities/performance.dart';
import '../repositories/performance_repository.dart';

class GetPerformanceHistoryUseCase {
  final PerformanceRepository repository;

  GetPerformanceHistoryUseCase({required this.repository});

  Future<Either<String, Map<String, List<Performance>>>> call({required List<String> playerUids}) async {
    return await repository.getPerformanceHistory(playerUids: playerUids);
  }
}
