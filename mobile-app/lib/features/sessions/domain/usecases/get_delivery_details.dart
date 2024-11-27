import '../entities/delivery.dart';
import '../repositories/session_repository.dart';

class GetDeliveryDetails {
  final SessionRepository repository;

  GetDeliveryDetails(this.repository);

  Future<Delivery> call(String deliveryId) async {
    return await repository.fetchDeliveryDetails(deliveryId);
  }
}