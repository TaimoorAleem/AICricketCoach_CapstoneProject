class UploadDeliveryResponse {
  final String videoUrl;
  final BallCharacteristics ball;
  final List<IdealShot> idealShots;

  UploadDeliveryResponse({
    required this.videoUrl,
    required this.ball,
    required this.idealShots,
  });

  factory UploadDeliveryResponse.fromJson(Map<String, dynamic> json) {
    return UploadDeliveryResponse(
      videoUrl: json['videoUrl'],
      ball: BallCharacteristics.fromJson(json['ballCharacteristics']),
      idealShots: (json['idealShot']['predicted_ideal_shots'] as List)
          .map((e) => IdealShot.fromJson(e))
          .toList(),
    );
  }
}

class BallCharacteristics {
  final String ballLength;
  final String ballLine;
  final double ballSpeed;
  final int batsmanPosition;

  BallCharacteristics({
    required this.ballLength,
    required this.ballLine,
    required this.ballSpeed,
    required this.batsmanPosition,
  });

  factory BallCharacteristics.fromJson(Map<String, dynamic> json) {
    return BallCharacteristics(
      ballLength: json['BallLength'],
      ballLine: json['BallLine'],
      ballSpeed: (json['BallSpeed'] as num).toDouble(),
      batsmanPosition: json['BatsmanPosition'],
    );
  }
}

class IdealShot {
  final String shot;
  final double confidenceScore;

  IdealShot({required this.shot, required this.confidenceScore});

  factory IdealShot.fromJson(Map<String, dynamic> json) {
    return IdealShot(
      shot: json['shot'],
      confidenceScore: (json['confidence_score'] as num).toDouble(),
    );
  }
}
