import '../repositories/shot_repository.dart';

class PredictShot {
  final ShotRepository repository;

  PredictShot(this.repository);

  Future<Map<String, dynamic>> call(Map<String, dynamic> inputData) {
    return repository.predictShot(inputData);
  }
}
