import '../entities/shot_prediction.dart';

abstract class ShotPredictionRepository {
  Future<ShotPrediction> predictShot(Map<String, dynamic> ballMetrics);
}
