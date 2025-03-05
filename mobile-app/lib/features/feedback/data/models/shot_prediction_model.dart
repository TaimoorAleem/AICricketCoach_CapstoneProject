import '../../domain/entities/shot_prediction.dart';

class ShotPredictionModel extends ShotPrediction {
  ShotPredictionModel({required super.shots});

  factory ShotPredictionModel.fromJson(Map<String, dynamic> json) {
    return ShotPredictionModel(
      shots: (json['predicted_ideal_shots'] as List)
          .map((shot) => PredictedShot(
        shot: shot['shot'],
        confidenceScore: shot['confidence_score'],
      ))
          .toList(),
    );
  }
}
