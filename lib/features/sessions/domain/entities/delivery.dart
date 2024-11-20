import 'package:equatable/equatable.dart';

/// Represents a Delivery entity in the domain layer.
/// A delivery corresponds to an individual ball in a cricket session,
/// including trajectory details, execution ratings, and other metadata.
class DeliveryEntity extends Equatable {
  final String id; // Unique identifier for the delivery.
  final double speed; // The speed of the ball in km/h.
  final double bounceHeight; // The height at which the ball bounces in meters.
  final String ballLine; // Horizontal position of the ball relative to the stumps (e.g., "off", "leg", "middle").
  final double ballLength; // Length of the delivery (e.g., "short", "good", "full").
  final int executionRating; // The player's self-assessed execution rating (0-10).
  final DateTime timestamp; // The time when the delivery occurred.

  /// Constructor to initialize the Delivery entity.
  const DeliveryEntity({
    required this.id,
    required this.speed,
    required this.bounceHeight,
    required this.ballLine,
    required this.ballLength,
    required this.executionRating,
    required this.timestamp,
  });

  /// Specifies the fields that determine equality.
  @override
  List<Object?> get props => [
    id,
    speed,
    bounceHeight,
    ballLine,
    ballLength,
    executionRating,
    timestamp,
  ];

  /// Provides a readable string representation of the Delivery object.
  @override
  String toString() {
    return 'Delivery(id: $id, speed: $speed, bounceHeight: $bounceHeight, '
        'ballLine: $ballLine, ballLength: $ballLength, executionRating: $executionRating, '
        'timestamp: $timestamp)';
  }
}