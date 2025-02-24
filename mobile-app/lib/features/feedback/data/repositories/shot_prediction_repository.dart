import '../../core/network/api_client.dart';
import '../../domain/entities/shot_prediction.dart';
import '../../domain/repositories/shot_prediction_repository.dart';
import '../models/shot_prediction_model.dart';

class ShotPredictionRepositoryImpl implements ShotPredictionRepository {
  final ApiClient apiClient;

  ShotPredictionRepositoryImpl(this.apiClient);

  @override
  Future<ShotPrediction> predictShot(Map<String, dynamic> ballMetrics) async {
    final response = await apiClient.post('/predict', ballMetrics);
    return ShotPredictionModel.fromJson(response);
  }
}
