import '../../../../core/network/dio_client.dart';

class SessionApiService {
  final DioClient dioClient;

  SessionApiService(this.dioClient);

  Future<Map<String, dynamic>> getSessions(String uid) async {
    final response = await dioClient.get(
      '/get-sessions',
      queryParameters: {'uid': uid},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getDeliveries(String sessionId) async {
    final response = await dioClient.get('/sessions/$sessionId/deliveries');
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> getDeliveryDetails(String deliveryId) async {
    final response = await dioClient.get('/deliveries/$deliveryId');
    return response.data as Map<String, dynamic>;
  }
}