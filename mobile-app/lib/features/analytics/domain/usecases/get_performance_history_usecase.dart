import 'package:dartz/dartz.dart';
import '../entities/performance.dart';
import '../repositories/performance_repository.dart';

class GetPerformanceHistoryUseCase {
  final PerformanceRepository repository;

  GetPerformanceHistoryUseCase({required this.repository});

  Future<Either<String, List<Performance>>> call() async {
    return await repository.getPerformanceHistory();
  }
}