import '../../domain/entities/delivery.dart';

class DeliveryModel {
  final String deliveryId;
  final double speed;
  final double bounceHeight;
  final double ballLength;
  final String horizontalPosition;
  final bool rightHandedBatsman;
  final double accuracy;
  final double executionRating;
  final String idealShot;
  final String videoUrl;
  final double? battingRating; // ✅ New field
  final String? feedback; // ✅ New field

  DeliveryModel({
    required this.deliveryId,
    required this.speed,
    required this.bounceHeight,
    required this.ballLength,
    required this.horizontalPosition,
    required this.rightHandedBatsman,
    required this.accuracy,
    required this.executionRating,
    required this.idealShot,
    required this.videoUrl,
    this.battingRating, // ✅ Optional
    this.feedback, // ✅ Optional
  });

  /// Factory method to create a DeliveryModel from JSON
  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      deliveryId: json['deliveryId'] as String,
      speed: (json['speed'] as num).toDouble(),
      bounceHeight: (json['bounceHeight'] as num).toDouble(),
      ballLength: (json['ballLength'] as num).toDouble(),
      horizontalPosition: json['horizontalPosition'] as String,
      rightHandedBatsman: json['rightHandedBatsman'] as bool,
      accuracy: (json['accuracy'] as num).toDouble(),
      executionRating: (json['executionRating'] as num).toDouble(),
      idealShot: json['idealShot'] as String,
      videoUrl: json['videoUrl'] as String,
      battingRating: json.containsKey('battingRating') ? (json['battingRating'] as num).toDouble() : null,
      feedback: json['feedback'] as String?,
    );
  }

  /// Converts DeliveryModel to a domain entity (Delivery)
  Delivery toDomain() {
    return Delivery(
      deliveryId: deliveryId,
      speed: speed,
      bounceHeight: bounceHeight,
      ballLength: ballLength,
      horizontalPosition: horizontalPosition,
      rightHandedBatsman: rightHandedBatsman,
      accuracy: accuracy,
      executionRating: executionRating,
      idealShot: idealShot,
      videoUrl: videoUrl,
      battingRating: battingRating,
      feedback: feedback,
    );
  }
}
