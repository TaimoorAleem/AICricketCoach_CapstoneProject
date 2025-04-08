import '../../../idealshot/domain/entities/ideal_shot.dart';
import '../../domain/entities/delivery.dart';

class DeliveryModel {
  final String deliveryId;
  final String ballLength;
  final String ballLine;
  final double ballSpeed;
  final int batsmanPosition;
  final String videoUrl;
  final List<IdealShot> idealShots;
  final double? battingRating;
  final String? feedback;

  DeliveryModel({
    required this.deliveryId,
    required this.ballLength,
    required this.ballLine,
    required this.ballSpeed,
    required this.batsmanPosition,
    required this.videoUrl,
    required this.idealShots,
    this.battingRating,
    this.feedback,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    final idealShotMap = json['idealShot'] as Map<String, dynamic>? ?? {};
    final predictedShots = idealShotMap['predicted_ideal_shots'] as List<dynamic>? ?? [];

    return DeliveryModel(
      deliveryId: json['deliveryId'] ?? '',
      ballLength: json['BallLength'] ?? '',
      ballLine: json['BallLine'] ?? '',
      ballSpeed: (json['BallSpeed'] is num) ? (json['BallSpeed'] as num).toDouble() : 0.0,
      batsmanPosition: (json['BatsmanPosition'] is int) ? json['BatsmanPosition'] : 0,
      videoUrl: json['videoUrl'] ?? '',
      idealShots: predictedShots.map((e) {
        final shotMap = e as Map<String, dynamic>;
        return IdealShot(
          shot: shotMap['shot'] ?? '',
          confidenceScore: (shotMap['confidence_score'] is num)
              ? (shotMap['confidence_score'] as num).toDouble()
              : 0.0,
        );
      }).toList(),
      battingRating: json['battingRating'] != null && json['battingRating'] is num
          ? (json['battingRating'] as num).toDouble()
          : null,
      feedback: json['feedback'],
    );
  }

  Delivery toEntity() {
    return Delivery(
      deliveryId: deliveryId,
      ballLength: ballLength,
      ballLine: ballLine,
      ballSpeed: ballSpeed,
      batsmanPosition: batsmanPosition,
      videoUrl: videoUrl,
      idealShots: idealShots,
      battingRating: battingRating,
      feedback: feedback,
    );
  }
}