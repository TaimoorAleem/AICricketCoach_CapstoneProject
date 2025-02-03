import 'package:dartz/dartz.dart';
import '../../domain/entities/performance.dart';
import '../../domain/repositories/performance_repository.dart';
import '../network/performance_api_service.dart';

class PerformanceRepositoryImpl implements PerformanceRepository {
  final PerformanceApiService apiService;

  PerformanceRepositoryImpl({required this.apiService});

  @override
  Future<Either<String, List<Performance>>> getPerformanceHistory() async {
    final result = await apiService.getPerformanceHistory();
    return result.fold(
          (error) => Left(error),
          (data) {
        final performanceHistory = (data['performanceHistory'] as List)
            .map((json) => Performance.fromJson(json))
            .toList();
        return Right(performanceHistory);
      },
    );
  }
}