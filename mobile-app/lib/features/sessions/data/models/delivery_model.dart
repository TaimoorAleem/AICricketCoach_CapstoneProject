import '../../domain/entities/delivery.dart';

class DeliveryModel {
  final String deliveryId;
  final double speed;
  final double bounceHeight;
  final double ballLength;
  final double horizontalPosition;
  final bool rightHandedBatsman;
  final double accuracy;
  final double executionRating;
  final String idealShot;

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

  // Convert from domain entity
  factory DeliveryModel.fromDomain(Delivery delivery) {
    return DeliveryModel(
      deliveryId: delivery.deliveryId,
      speed: delivery.speed,
      bounceHeight: delivery.bounceHeight,
      ballLength: delivery.ballLength,
      horizontalPosition: delivery.horizontalPosition,
      rightHandedBatsman: delivery.rightHandedBatsman,
      accuracy: delivery.accuracy,
      executionRating: delivery.executionRating,
      idealShot: delivery.idealShot,
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
    };
  }

  // Convert from JSON
  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      deliveryId: json['deliveryId'],
      speed: json['speed'],
      bounceHeight: json['bounceHeight'],
      ballLength: json['ballLength'],
      horizontalPosition: json['horizontalPosition'],
      rightHandedBatsman: json['rightHandedBatsman'],
      accuracy: json['accuracy'],
      executionRating: json['executionRating'],
      idealShot: json['idealShot'],
    );
  }
}