import 'package:dartz/dartz.dart';
import '../../domain/entities/performance.dart';
import '../../domain/repositories/performance_repository.dart';
import '../network/performance_api_service.dart';

class PerformanceRepositoryImpl implements PerformanceRepository {
  final PerformanceApiService apiService;

  PerformanceRepositoryImpl({required this.apiService});

  @override
  Future<Either<String, Map<String, List<Performance>>>> getPerformanceHistory({required List<String> playerUids}) async {
    final result = await apiService.fetchPerformanceHistory(playerUids: playerUids);

    return result.fold(
          (error) => Left(error),
          (data) async {
        try {
          if (!data.containsKey('data')) {
            return Left("Invalid response format: missing 'data' key.");
          }

          final Map<String, List<Performance>> performanceMap = {};

          for (var uid in playerUids) {
            if (data['data'].containsKey(uid)) {
              final playerSessions = data['data'][uid] as List<dynamic>;

              final List<Performance> playerPerformance = playerSessions
                  .where((session) => (session['performance'] as List).isNotEmpty)
                  .map((session) {
                final perfData = session['performance'][0];

                return Performance(
                  date: session['date'],
                  averageExecutionRating: (perfData['averageExecutionRating'] ?? 0.0).toDouble(),
                  averageSpeed: (perfData['averageSpeed'] ?? 0.0).toDouble(),
                );
              }).toList();

              if (playerPerformance.isNotEmpty) {
                performanceMap[uid] = playerPerformance;
              }
            }
          }

          if (performanceMap.isEmpty) {
            return Left("No valid performance data found for the selected players.");
          }

          return Right(performanceMap);
        } catch (e) {
          return Left("Error parsing performance data: $e");
        }
      },
    );
  }
}
