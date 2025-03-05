import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import '../../../../resources/dio_client.dart';

class PerformanceApiService {
  final DioClient dioClient;

  PerformanceApiService(this.dioClient);

  Future<Either<String, Map<String, dynamic>>> fetchPerformanceHistory({required List<String> playerUids}) async {
    try {
      final response = await dioClient.get(
        'get-performance-history',
        queryParameters: {
          'uid_list': jsonEncode(playerUids),
        },
      );

      return Right(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      return Left(e.response?.data?['message'] ?? 'Failed to fetch performance history.');
    } catch (e) {
      return Left('An unexpected error occurred: $e');
    }
  }
}
