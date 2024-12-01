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
  });

  // Convert to domain entity
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
    );
  }

  // Convert from JSON
  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      deliveryId: json['deliveryId'],
      speed: json['speed'].toDouble(),
      bounceHeight: json['bounceHeight'].toDouble(),
      ballLength: json['ballLength'].toDouble(),
      horizontalPosition: json['horizontalPosition'],
      rightHandedBatsman: json['rightHandedBatsman'],
      accuracy: json['accuracy'].toDouble(),
      executionRating: json['executionRating'].toDouble(),
      idealShot: json['idealShot'],
      videoUrl: json['videoUrl'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'deliveryId': deliveryId,
      'speed': speed,
      'bounceHeight': bounceHeight,
      'ballLength': ballLength,
      'horizontalPosition': horizontalPosition,
      'rightHandedBatsman': rightHandedBatsman,
      'accuracy': accuracy,
      'executionRating': executionRating,
      'idealShot': idealShot,
      'videoUrl': videoUrl,
    };
  }
}