import '../models/session_model.dart';
import '../models/delivery_model.dart';
import '../network/sessions_api_service.dart';

class SessionsRemoteDataSource {
  final SessionApiService apiService;

  SessionsRemoteDataSource(this.apiService);

  Future<List<SessionModel>> getSessions(String uid) async {
    final response = await apiService.getSessions(uid);
    return response['sessions']
        .map<SessionModel>((json) => SessionModel.fromJson(json))
        .toList();
  }

  Future<List<DeliveryModel>> getDeliveries(String sessionId) async {
    final deliveriesJson = await apiService.getDeliveries(sessionId);
    return deliveriesJson.map((json) => DeliveryModel.fromJson(json)).toList();
  }

  Future<DeliveryModel> getDeliveryDetails(String deliveryId) async {
    final deliveryJson = await apiService.getDeliveryDetails(deliveryId);
    return DeliveryModel.fromJson(deliveryJson);
  }
}
