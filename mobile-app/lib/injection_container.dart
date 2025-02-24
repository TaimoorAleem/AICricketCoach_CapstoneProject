import 'package:get_it/get_it.dart';
import 'core/network/api_client.dart';
import 'data/repositories/shot_prediction_repository.dart';
import 'domain/repositories/shot_prediction_repository.dart';
import 'domain/usecases/predict_shot.dart';

final GetIt sl = GetIt.instance;

void init() {
  // Register API Client
  sl.registerLazySingleton(() => ApiClient(
      baseUrl: "https://shot-recommendation-api-857244658015.us-central1.run.app"));

  // Register Repository
  sl.registerLazySingleton<ShotPredictionRepository>(
          () => ShotPredictionRepositoryImpl(sl()));

  // Register UseCase
  sl.registerLazySingleton(() => PredictShot(sl()));
}
