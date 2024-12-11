import '../../domain/repositories/shot_repository.dart';
import '../../data/data_sources/api_service.dart';

class ShotRepositoryImpl implements ShotRepository {
  final ApiService apiService;

  ShotRepositoryImpl(this.apiService);

  @override
  Future<Map<String, dynamic>> predictShot(Map<String, dynamic> inputData) {
    return apiService.predictShot(inputData);
  }
}
