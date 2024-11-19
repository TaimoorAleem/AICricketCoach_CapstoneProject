import 'package:equatable/equatable.dart';

/// Represents a Session entity in the domain layer.
class Session extends Equatable {
  final String id; // Unique identifier for the session.
  final DateTime dateTime; // The date and time when the session was completed.
  final int deliveryCount; // Total number of deliveries in the session.
  final double averageExecutionRating; // Average execution quality rating for all deliveries.
  final double averageSpeed; // Average speed of all deliveries.
  final double averageAccuracy; // Average accuracy rating of all deliveries.

  /// Constructor to initialize the Session entity.
  const Session({
    required this.id,
    required this.dateTime,
    required this.deliveryCount,
    required this.averageExecutionRating,
    required this.averageSpeed,
    required this.averageAccuracy,
  });

  /// Specifies the fields that determine equality.
  @override
  List<Object?> get props => [
    id,
    dateTime,
    deliveryCount,
    averageExecutionRating,
    averageSpeed,
    averageAccuracy,
  ];

  /// Provides a readable string representation of the Session object.
  @override
  String toString() {
    return 'Session(id: $id, dateTime: $dateTime, '
        'deliveryCount: $deliveryCount, averageExecutionRating: $averageExecutionRating, '
        'averageSpeed: $averageSpeed, averageAccuracy: $averageAccuracy)';
  }
}