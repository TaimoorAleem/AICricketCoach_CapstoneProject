import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/session.dart';

/// Data model for a Session, used in the data layer for mapping between Firestore and the domain entity.
class SessionModel extends SessionEntity {
  SessionModel({
    String? id,
    DateTime? dateTime,
    int? deliveryCount,
    double? averageExecutionRating,
    double? averageSpeed,
    double? averageAccuracy,
  }) : super(
        id: id ?? '', // Default to an empty string if null
        dateTime: dateTime ?? DateTime.now(), // Default to the current date if null
        deliveryCount: deliveryCount ?? 0, // Default to 0 if null
        averageExecutionRating: averageExecutionRating ?? 0.0, // Default to 0.0 if null
        averageSpeed: averageSpeed ?? 0.0, // Default to 0.0 if null
        averageAccuracy: averageAccuracy ?? 0.0, // Default to 0.0 if null
      );

  /// Converts a Firestore document to a SessionModel.
  factory SessionModel.fromJson(Map<String, dynamic> json, String id) {
    return SessionModel(
      id: id,
      dateTime: (json['dateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      deliveryCount: json['deliveryCount'] ?? 0,
      averageExecutionRating:
      (json['averageExecutionRating'] as num?)?.toDouble() ?? 0.0,
      averageSpeed: (json['averageSpeed'] as num?)?.toDouble() ?? 0.0,
      averageAccuracy: (json['averageAccuracy'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Converts a SessionEntity to a SessionModel.
  static SessionModel fromEntity(SessionEntity entity) {
    return SessionModel(
      id: entity.id,
      dateTime: entity.dateTime,
      deliveryCount: entity.deliveryCount,
      averageExecutionRating: entity.averageExecutionRating,
      averageSpeed: entity.averageSpeed,
      averageAccuracy: entity.averageAccuracy,
    );
  }

  /// Converts a SessionModel to a Firestore-compatible JSON object.
  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime,
      'deliveryCount': deliveryCount,
      'averageExecutionRating': averageExecutionRating,
      'averageSpeed': averageSpeed,
      'averageAccuracy': averageAccuracy,
    };
  }
}