class Delivery {
  final String deliveryId;
  final double speed;
  final double bounceHeight;
  final double ballLength;
  final double horizontalPosition;
  final bool rightHandedBatsman;
  final double accuracy;
  final double executionRating;
  final String idealShot; // Recommended shot for this delivery

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
  });
}