import '../entities/shot_prediction.dart';
import '../repositories/shot_prediction_repository.dart';

class PredictShot {
  final ShotPredictionRepository repository;

  PredictShot(this.repository);

  Future<ShotPrediction> call(Map<String, dynamic> ballMetrics) {
    return repository.predictShot(ballMetrics);
  }
}
