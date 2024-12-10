import 'package:equatable/equatable.dart';

class Delivery extends Equatable {
  final String deliveryId;
  final double speed;
  final double accuracy;
  final double bounceHeight;
  final double ballLength;
  final String horizontalPosition;
  final String idealShot;
  final bool rightHandedBatsman;
  final double executionRating; // Add this field
  final String? videoUrl;

  const Delivery({
    required this.deliveryId,
    required this.speed,
    required this.accuracy,
    required this.bounceHeight,
    required this.ballLength,
    required this.horizontalPosition,
    required this.idealShot,
    required this.rightHandedBatsman,
    required this.executionRating, // Initialize this field
    this.videoUrl,
  });

  @override
  List<Object?> get props => [
    deliveryId,
    speed,
    accuracy,
    bounceHeight,
    ballLength,
    horizontalPosition,
    idealShot,
    rightHandedBatsman,
    executionRating, // Include this field in props
    videoUrl,
  ];
}