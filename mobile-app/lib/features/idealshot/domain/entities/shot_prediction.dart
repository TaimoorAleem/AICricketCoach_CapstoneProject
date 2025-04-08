class PredictedShot {
  final String shot;
  final double confidenceScore;

  PredictedShot({required this.shot, required this.confidenceScore});
}

class ShotPrediction {
  final List<PredictedShot> shots;

  ShotPrediction({required this.shots});
}
