import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/session.dart';

/// Data model for a Session, used in the data layer for mapping
/// between Firestore and the domain entity.
class SessionModel extends SessionEntity {
  const SessionModel({
    required String id,
    required DateTime dateTime,
    required int deliveryCount,
    required double averageExecutionRating,
    required double averageSpeed,
    required double averageAccuracy,
  }) : super(
    id: id,
    dateTime: dateTime,
    deliveryCount: deliveryCount,
    averageExecutionRating: averageExecutionRating,
    averageSpeed: averageSpeed,
    averageAccuracy: averageAccuracy,
  );

  /// Converts a Firestore document to a SessionModel.
  factory SessionModel.fromJson(Map<String, dynamic> json, String id) {
    return SessionModel(
      id: id,
      dateTime: (json['dateTime'] as Timestamp).toDate(),
      deliveryCount: json['deliveryCount'],
      averageExecutionRating: json['averageExecutionRating'].toDouble(),
      averageSpeed: json['averageSpeed'].toDouble(),
      averageAccuracy: json['averageAccuracy'].toDouble(),
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
