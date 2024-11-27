import '../../domain/entities/session.dart';

class SessionModel {
  final String sessionId;
  final String date; // ISO 8601 format
  final double averageSpeed;
  final double averageAccuracy;
  final double averageExecutionRating;
  final List<String> deliveryIds;

  SessionModel({
    required this.sessionId,
    required this.date,
    required this.averageSpeed,
    required this.averageAccuracy,
    required this.averageExecutionRating,
    required this.deliveryIds,
  });

  // Convert to domain entity
  Session toDomain() {
    return Session(
      sessionId: sessionId,
      date: DateTime.parse(date),
      averageSpeed: averageSpeed,
      averageAccuracy: averageAccuracy,
      averageExecutionRating: averageExecutionRating,
      deliveryIds: deliveryIds,
    );
  }

  // Convert from domain entity
  factory SessionModel.fromDomain(Session session) {
    return SessionModel(
      sessionId: session.sessionId,
      date: session.date.toIso8601String(),
      averageSpeed: session.averageSpeed,
      averageAccuracy: session.averageAccuracy,
      averageExecutionRating: session.averageExecutionRating,
      deliveryIds: session.deliveryIds,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'date': date,
      'averageSpeed': averageSpeed,
      'averageAccuracy': averageAccuracy,
      'averageExecutionRating': averageExecutionRating,
      'deliveryIds': deliveryIds,
    };
  }

  // Convert from JSON
  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionId: json['sessionId'],
      date: json['date'],
      averageSpeed: json['averageSpeed'],
      averageAccuracy: json['averageAccuracy'],
      averageExecutionRating: json['averageExecutionRating'],
      deliveryIds: List<String>.from(json['deliveryIds']),
    );
  }
}