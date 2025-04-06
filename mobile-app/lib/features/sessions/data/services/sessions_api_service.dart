import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../resources/api_urls.dart';
import '../../../../resources/dio_client.dart';
import '../../../../resources/service_locator.dart';

abstract class SessionsApiService {
  Future<Either<String, Map<String, dynamic>>> fetchSessions(String playerUid);
}

class SessionsApiServiceImpl extends SessionsApiService {
  @override
  Future<Either<String, Map<String, dynamic>>> fetchSessions(String playerUid) async {
    try {
      final response = await sl<DioClient>().get(
        ApiUrl.getSessions,
        queryParameters: {'uid': playerUid},
      );
      return Right(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? 'Failed to fetch sessions');
    } catch (e) {
      return Left('An error occurred: $e');
    }
  }
}
