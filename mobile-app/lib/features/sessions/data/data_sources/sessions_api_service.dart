import 'package:ai_cricket_coach/resources/api_urls.dart';

import '../../../../resources/dio_client.dart';

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
    } catch (e) {
      throw Exception("Failed to submit feedback: $e");
    }
  }
}
