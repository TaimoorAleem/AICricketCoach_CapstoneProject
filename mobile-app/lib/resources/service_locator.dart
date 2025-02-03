import 'package:ai_cricket_coach/features/authentication/data/data_sources/auth_api_service.dart';
import 'package:ai_cricket_coach/features/authentication/data/repositories/auth_repo_impl.dart';
import 'package:ai_cricket_coach/features/authentication/domain/repositories/auth_repo.dart';
import 'package:ai_cricket_coach/features/authentication/domain/usecases/is_authenticated_usecase.dart';
import 'package:ai_cricket_coach/features/authentication/domain/usecases/login_usecase.dart';
import 'package:ai_cricket_coach/features/authentication/domain/usecases/signup_usecase.dart';
import 'package:ai_cricket_coach/features/sessions/data/network/sessions_api_service.dart';
import 'package:ai_cricket_coach/features/sessions/data/repositories/session_repository_impl.dart';
import 'package:ai_cricket_coach/features/sessions/domain/repositories/session_repository.dart';
import 'package:ai_cricket_coach/features/sessions/domain/usecases/get_sessions_usecase.dart';
import 'package:ai_cricket_coach/features/user_profile/data/data_sources/user_profile_service.dart';
import 'package:ai_cricket_coach/features/user_profile/data/repositories/user_profile_repo_impl.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/repositories/user_profile_repo.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/usecases/edit_profile.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/usecases/get_user_profile.dart';
import 'package:get_it/get_it.dart';
import '../features/analytics/data/network/performance_api_service.dart';
import '../features/analytics/data/repositories/performance_repository_impl.dart';
import '../features/analytics/domain/repositories/performance_repository.dart';
import '../features/analytics/domain/usecases/get_performance_history_usecase.dart';
import '../features/feedback/data/data_sources/api_service.dart';
import '../features/feedback/data/repositories/shot_repository_impl.dart';
import '../features/feedback/domain/repositories/shot_repository.dart';
import '../features/feedback/domain/usecases/predict_shot.dart';
import 'dio_client.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Dio Client
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // API Services
  sl.registerLazySingleton<AuthService>(() => AuthApiServiceImpl());
  sl.registerSingleton<SessionApiService>(
    SessionApiService(sl<DioClient>()),
  );
  sl.registerLazySingleton<UserProfileService>(
          () => UserProfileServiceImpl()
  );
  sl.registerSingleton<ApiService>(ApiService('http://10.0.2.2:5000'));
  sl.registerSingleton<PerformanceApiService>(PerformanceApiService(sl<DioClient>()));

  // Repositories
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl());
  sl.registerLazySingleton<UserProfileRepo>(() => UserProfileRepoImpl());
  sl.registerSingleton<SessionsRepository>(
    SessionsRepositoryImpl(apiService: sl<SessionApiService>()),
  );
  sl.registerSingleton<ShotRepository>(ShotRepositoryImpl(sl<ApiService>()));
  sl.registerSingleton<PerformanceRepository>(PerformanceRepositoryImpl(apiService: sl<PerformanceApiService>()));

  // Use Cases
  sl.registerLazySingleton<SignupUseCase>(() => SignupUseCase());
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase());
  sl.registerLazySingleton<IsAuthenticatedUseCase>(
          () => IsAuthenticatedUseCase());
  sl.registerLazySingleton<GetUserProfileUseCase>(
          () => GetUserProfileUseCase());
  sl.registerLazySingleton<EditProfileUseCase>(() => EditProfileUseCase());
  sl.registerSingleton<GetSessionsUseCase>(
    GetSessionsUseCase(repository: sl<SessionsRepository>()),
  );
  sl.registerSingleton<PredictShot>(PredictShot(sl<ShotRepository>()));
  sl.registerSingleton<GetPerformanceHistoryUseCase>(
      GetPerformanceHistoryUseCase(repository: sl<PerformanceRepository>()));
}
