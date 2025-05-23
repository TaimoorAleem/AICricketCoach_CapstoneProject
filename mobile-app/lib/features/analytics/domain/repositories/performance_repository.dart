import 'package:dartz/dartz.dart';
import '../entities/performance.dart';

abstract class PerformanceRepository {
  Future<Either<String, Map<String, List<Performance>>>> getPerformanceHistory({required List<String> playerUids});
}
