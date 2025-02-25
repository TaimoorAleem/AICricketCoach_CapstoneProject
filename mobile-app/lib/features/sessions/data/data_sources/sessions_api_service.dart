import '../../../../resources/dio_client.dart';

class SessionApiService {
  final DioClient dioClient;

  SessionApiService(this.dioClient);

  Future<Map<String, dynamic>> fetchSessions(String playerUid) async {
    final response = await dioClient.get(
      'get-sessions',
      queryParameters: {'uid': playerUid},
    );
    return response.data as Map<String, dynamic>;
  }
}
