class Delivery {
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

  Delivery({
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
}