import 'package:ai_cricket_coach/resources/api_urls.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import '../../../../resources/api_urls.dart';
import '../../../../resources/dio_client.dart';

abstract class PerformanceService {
  Future<Either<String, Map<String, dynamic>>> fetchPerformanceHistory({required List<String> playerUids});
}

class PerformanceApiService implements PerformanceService {
  final DioClient dioClient;

  PerformanceApiService(this.dioClient);

  @override
  Future<Either<String, Map<String, dynamic>>> fetchPerformanceHistory({required List<String> playerUids}) async {
    try {
      final response = await dioClient.get(
        ApiUrl.getPerformance,
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
