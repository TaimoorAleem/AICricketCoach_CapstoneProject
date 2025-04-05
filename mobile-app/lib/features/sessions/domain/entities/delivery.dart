import '../../../idealshot/domain/entities/ideal_shot.dart';

class Delivery {
  final String deliveryId;
  final String ballLength;
  final String ballLine;
  final double ballSpeed;
  final int batsmanPosition;
  final String videoUrl;
  final List<IdealShot> idealShots;
  final double? battingRating;
  final String? feedback;

  Delivery({
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

  factory Delivery.fromJson(Map<String, dynamic> json) {
    final shots = (json['idealShot']['predicted_ideal_shots'] as List)
        .map((e) => IdealShot.fromJson(e))
        .toList();

    return Delivery(
      deliveryId: json['deliveryId'],
      ballLength: json['BallLength'],
      ballLine: json['BallLine'],
      ballSpeed: (json['BallSpeed'] as num).toDouble(),
      batsmanPosition: json['BatsmanPosition'],
      videoUrl: json['videoUrl'],
      idealShots: shots,
    );
  }

  Delivery copyWith({
    double? battingRating,
    String? feedback,
  }) {
    return Delivery(
      deliveryId: deliveryId,
      ballLength: ballLength,
      ballLine: ballLine,
      ballSpeed: ballSpeed,
      batsmanPosition: batsmanPosition,
      videoUrl: videoUrl,
      idealShots: idealShots,
      battingRating: battingRating ?? this.battingRating,
      feedback: feedback ?? this.feedback,
    );
  }
}
