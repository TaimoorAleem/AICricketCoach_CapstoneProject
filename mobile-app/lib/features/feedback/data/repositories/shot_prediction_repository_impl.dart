import 'package:ai_cricket_coach/resources/api_urls.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/shot_prediction.dart';
import '../../domain/repositories/shot_prediction_repository.dart';
import '../../../../resources/dio_client.dart';
import '../models/shot_prediction_model.dart';

class ShotPredictionRepositoryImpl implements ShotPredictionRepository {
  final DioClient dioClient;

  ShotPredictionRepositoryImpl(this.dioClient);

  @override
  Future<ShotPrediction> predictShot(Map<String, dynamic> ballMetrics) async {
    try {
      final Response response = await dioClient.post(
        ApiUrl.predictShot,
        data: ballMetrics,
        overrideBaseUrl: "https://shot-recommendation-api-857244658015.us-central1.run.app",
      );

      return ShotPredictionModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch shot prediction: $e');
    }
  }
}
