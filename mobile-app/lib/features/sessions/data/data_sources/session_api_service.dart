import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../resources/api_urls.dart';
import '../../../../resources/dio_client.dart';
import '../../domain/entities/delivery.dart';

/// Abstract class for sessions API operations
abstract class SessionsApiService {
  Future<Either<String, Map<String, dynamic>>> fetchSessions(String playerUid);

  Future<Either<String, void>> addFeedback({
    required String playerId,
    required String sessionId,
    required String deliveryId,
    required double battingRating,
    required String feedback,
  });

  Future<Either<String, void>> addDelivery({
    required String playerId,
    required String sessionId,
    required Delivery delivery,
  });
}

/// Implementation of the abstract SessionApiService
class SessionsApiServiceImpl implements SessionsApiService {
  final DioClient dioClient;

  SessionsApiServiceImpl(this.dioClient);

  @override
  Future<Either<String, Map<String, dynamic>>> fetchSessions(String playerUid) async {
    try {
      final response = await dioClient.get(
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

  @override
  Future<Either<String, void>> addFeedback({
    required String playerId,
    required String sessionId,
    required String deliveryId,
    required double battingRating,
    required String feedback,
  }) async {
    try {
      await dioClient.post(
        'add-feedback',
        data: {
          "playerId": playerId,
          "sessionId": sessionId,
          "deliveryId": deliveryId,
          "battingRating": battingRating,
          "feedback": feedback,
        },
      );
      return const Right(null);
    } catch (e) {
      return Left('Failed to add feedback: $e');
    }
  }

  @override
  Future<Either<String, void>> addDelivery({
    required String playerId,
    required String sessionId,
    required Delivery delivery,
  }) async {
    try {
      await dioClient.post(
        'add-delivery',
        data: {
          "playerId": playerId,
          "sessionId": sessionId,
          "deliveryId": delivery.deliveryId,
          "BallLength": delivery.ballLength,
          "BallLine": delivery.ballLine,
          "BallSpeed": delivery.ballSpeed,
          "BatsmanPosition": delivery.batsmanPosition,
          "videoUrl": delivery.videoUrl,
          "idealShot": {
            "predicted_ideal_shots": delivery.idealShots.map((s) => {
              "shot": s.shot,
              "confidence_score": s.confidenceScore,
            }).toList(),
          },
        },
      );
      return const Right(null);
    } catch (e) {
      return Left('Failed to add delivery: $e');
    }
  }
}
