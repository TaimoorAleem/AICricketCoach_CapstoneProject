import 'delivery_model.dart';
import '../../domain/entities/session.dart';

class SessionModel {
  final String sessionId;
  final String date;
  final double averageSpeed;
  final double averageAccuracy;
  final double averageExecutionRating;
  final List<DeliveryModel> deliveries;

  SessionModel({
    required this.sessionId,
    required this.date,
    required this.averageSpeed,
    required this.averageAccuracy,
    required this.averageExecutionRating,
    required this.deliveries,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'date': date,
      'averageSpeed': averageSpeed,
      'averageAccuracy': averageAccuracy,
      'averageExecutionRating': averageExecutionRating,
      'deliveries': deliveries.map((delivery) => delivery.toJson()).toList(),
    };
  }

  /// Convert from JSON
  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionId: json['sessionId'],
      date: json['date'],
      averageSpeed: (json['averageSpeed'] as num).toDouble(),
      averageAccuracy: (json['averageAccuracy'] as num).toDouble(),
      averageExecutionRating: (json['averageExecutionRating'] as num).toDouble(),
      deliveries: (json['deliveries'] as List<dynamic>)
          .map((delivery) => DeliveryModel.fromJson(delivery))
          .toList(),
    );
  }

  /// Convert to domain entity
  Session toDomain() {
    return Session(
      sessionId: sessionId,
      date: DateTime.parse(date),
      averageSpeed: averageSpeed,
      averageAccuracy: averageAccuracy,
      averageExecutionRating: averageExecutionRating,
      deliveries: deliveries.map((delivery) => delivery.toDomain()).toList(),
    );
  }
}