import '../../domain/entities/session.dart';
import 'delivery_model.dart';

class SessionModel {
  final String sessionId;
  final String date;
  final Map<String, dynamic> performance;
  final List<DeliveryModel> deliveries;

  SessionModel({
    required this.sessionId,
    required this.date,
    required this.performance,
    required this.deliveries,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    print("📥 SessionModel JSON: $json");

    final deliveriesJson = json['deliveries'] as List<dynamic>? ?? [];

    return SessionModel(
      sessionId: json['sessionId'] ?? '',
      date: json['date'] ?? '',
      performance: Map<String, dynamic>.from(json['performance'] ?? {}),
      deliveries: deliveriesJson
          .map((e) => DeliveryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Session toEntity() {
    return Session(
      sessionId: sessionId,
      date: date,
      performance: performance,
      deliveries: deliveries.map((e) => e.toEntity()).toList(), // This is where DeliveryModel → Delivery
    );
  }
}
