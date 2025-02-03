import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../resources/dio_client.dart';

class PerformanceApiService {
  final DioClient dioClient;

  PerformanceApiService(this.dioClient);

  Future<Either<String, Map<String, dynamic>>> getPerformanceHistory() async {
    try {
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final uid = sharedPreferences.getString('uid');

      final response = await dioClient.get(
        'get-performance-history',
        queryParameters: {'uid': uid},
      );

      return Right(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      return Left(e.response?.data?['message'] ?? 'Failed to fetch performance history.');
    } catch (e) {
      return Left('An unexpected error occurred: $e');
    }
  }
}