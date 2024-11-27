import '../../../../core/network/dio_client.dart';

class SessionApiService {
  final DioClient dioClient;

  SessionApiService(this.dioClient);

  Future<List<dynamic>> getSessions() async {
    final response = await dioClient.get('/sessions');
    return response.data as List<dynamic>;
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