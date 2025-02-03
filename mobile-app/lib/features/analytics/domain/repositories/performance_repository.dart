import 'package:dartz/dartz.dart';
import '../entities/performance.dart';

abstract class PerformanceRepository {
  Future<Either<String, List<Performance>>> getPerformanceHistory();
}