import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ Import for retrieving UID
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
          (data) async {
        // ✅ Retrieve the current user UID from shared preferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? uid = prefs.getString('uid');

        // ✅ Ensure UID exists
        if (uid == null || !data['data'].containsKey(uid)) {
          return Left("User data not found");
        }

        // ✅ Extract user's performance history
        final performanceHistory = (data['data'][uid] as List)
            .map((json) => Performance.fromJson(json))
            .toList();

        return Right(performanceHistory);
      },
    );
  }
}
