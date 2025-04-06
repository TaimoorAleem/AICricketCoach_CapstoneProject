import '../../../../resources/api_urls.dart';
import '../../../../resources/dio_client.dart';
import '../../domain/entities/delivery.dart';

class SessionApiService {
  final DioClient dioClient;

  SessionApiService(this.dioClient);

  Future<Map<String, dynamic>> fetchSessions(String playerUid) async {
    final response = await dioClient.get(
      ApiUrl.getSessions,
      queryParameters: {'uid': playerUid},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<void> addFeedback({
    required String playerId,
    required String sessionId,
    required String deliveryId,
    required double battingRating,
    required String feedback,
  }) async {
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
  }

  Future<void> addDelivery({
    required String playerId,
    required String sessionId,
    required Delivery delivery,
  }) async {
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
  }
}
