import '../../domain/entities/session.dart';
import 'delivery_model.dart';

class SessionModel {
  final String sessionId;
  final String date;
  final List<DeliveryModel> deliveries;

  SessionModel({
    required this.sessionId,
    required this.date,
    required this.deliveries,
  });

  /// Factory method to create a SessionModel from JSON
  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionId: json['sessionId'] as String,
      date: json['date'] as String,
      deliveries: (json['deliveries'] as List)
          .map((deliveryJson) => DeliveryModel.fromJson(deliveryJson))
          .toList(),
    );
  }

  /// Converts SessionModel to a domain entity (Session)
  Session toEntity() {
    return Session(
      sessionId: sessionId,
      date: date,
      deliveries: deliveries.map((delivery) => delivery.toDomain()).toList(),
    );
  }
}
