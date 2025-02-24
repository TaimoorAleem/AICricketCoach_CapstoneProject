import '../entities/shot_prediction.dart';
import '../repositories/shot_prediction_repository.dart';

class PredictShotUseCase {
  final ShotPredictionRepository repository;

  PredictShotUseCase(this.repository);

  Future<ShotPrediction> call(Map<String, dynamic> ballMetrics) async {
    return await repository.predictShot(ballMetrics);
  }
}
