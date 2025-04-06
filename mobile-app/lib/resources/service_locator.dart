import 'package:get_it/get_it.dart';
import '../features/sessions/data/data_sources/session_api_service.dart';
import '../resources/dio_client.dart';

// Auth
import '../features/authentication/data/data_sources/auth_api_service.dart';
import '../features/authentication/data/repositories/auth_repo_impl.dart';
import '../features/authentication/domain/repositories/auth_repo.dart';
import '../features/authentication/domain/usecases/is_authenticated_usecase.dart';
import '../features/authentication/domain/usecases/login_usecase.dart';
import '../features/authentication/domain/usecases/signup_usecase.dart';
import '../features/authentication/domain/usecases/create_profile.dart';
import '../features/authentication/domain/usecases/logout_usecase.dart';
import '../features/authentication/domain/usecases/send_code_usecase.dart';
import '../features/authentication/presentation/bloc/AuthCubit.dart';

// User Profile
import '../features/user_profile/data/data_sources/user_profile_service.dart';
import '../features/user_profile/data/repositories/user_profile_repo_impl.dart';
import '../features/user_profile/domain/repositories/user_profile_repo.dart';
import '../features/user_profile/domain/usecases/delete_account_usecase.dart';
import '../features/user_profile/domain/usecases/edit_pfp_usecase.dart';
import '../features/user_profile/domain/usecases/edit_profile.dart';
import '../features/user_profile/domain/usecases/get_user_profile.dart';
import '../features/user_profile/domain/usecases/get_profile_picture.dart';

// Sessions
import '../features/sessions/data/repositories/sessions_repository_impl.dart';
import '../features/sessions/domain/repositories/sessions_repository.dart';
import '../features/sessions/domain/usecases/get_sessions_usecase.dart';

// Analytics
import '../features/analytics/data/network/performance_api_service.dart';
import '../features/analytics/data/repositories/performance_repository_impl.dart';
import '../features/analytics/domain/repositories/performance_repository.dart';
import '../features/analytics/domain/usecases/get_performance_history_usecase.dart';

// Coaches
import '../features/coaches/data/data_sources/player_api_service.dart';
import '../features/coaches/data/repositories/player_repository_impl.dart';
import '../features/coaches/domain/repositories/player_repository.dart';
import '../features/coaches/domain/usecases/get_players_usecase.dart';
import '../features/coaches/domain/usecases/get_players_performance_usecase.dart';

// Feedback (commented for now; uncomment if you add it later)
// import '../features/feedback/data/repositories/shot_prediction_repository_impl.dart';
// import '../features/feedback/domain/repositories/shot_prediction_repository.dart';
// import '../features/feedback/domain/usecases/predict_shot_usecase.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register DioClient asynchronously
  sl.registerSingletonAsync<DioClient>(() async => await DioClient.init());

  // Wait for async singletons to finish initializing
  await sl.allReady();

  // API Services
  sl.registerLazySingleton<AuthService>(() => AuthApiServiceImpl());
  sl.registerLazySingleton<UserProfileService>(() => UserProfileServiceImpl());
  sl.registerLazySingleton<SessionsApiService>(() => SessionsApiServiceImpl(sl<DioClient>()));
  sl.registerLazySingleton<PerformanceApiService>(() => PerformanceApiService(sl<DioClient>()));
  sl.registerLazySingleton<PlayerApiService>(() => PlayerApiService(sl<DioClient>()));

  // Repositories
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl());
  sl.registerLazySingleton<UserProfileRepo>(() => UserProfileRepoImpl());
  sl.registerLazySingleton<SessionsRepository>(() => SessionsRepositoryImpl(apiService: sl<SessionsApiService>()));
  sl.registerLazySingleton<PerformanceRepository>(() => PerformanceRepositoryImpl(apiService: sl<PerformanceApiService>()));
  sl.registerLazySingleton<PlayerRepository>(() => PlayerRepositoryImpl(apiService: sl<PlayerApiService>()));

  // Bloc / Cubit
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit());

  // Use Cases
  sl.registerLazySingleton<SignupUseCase>(() => SignupUseCase());
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase());
  sl.registerLazySingleton<LogOutUseCase>(() => LogOutUseCase());
  sl.registerLazySingleton<CreateProfileUseCase>(() => CreateProfileUseCase());
  sl.registerLazySingleton<EditPFPUseCase>(() => EditPFPUseCase());
  sl.registerLazySingleton<SendCodeUseCase>(() => SendCodeUseCase());
  sl.registerLazySingleton<IsAuthenticatedUseCase>(() => IsAuthenticatedUseCase());
  sl.registerLazySingleton<GetUserProfileUseCase>(() => GetUserProfileUseCase());
  sl.registerLazySingleton<GetProfilePictureUseCase>(() => GetProfilePictureUseCase());
  sl.registerLazySingleton<EditProfileUseCase>(() => EditProfileUseCase());
  sl.registerLazySingleton<DeleteAccountUseCase>(() => DeleteAccountUseCase());
  sl.registerLazySingleton<GetSessionsUseCase>(() => GetSessionsUseCase(sl<SessionsRepository>()));
  sl.registerLazySingleton<GetPerformanceHistoryUseCase>(() => GetPerformanceHistoryUseCase(repository: sl<PerformanceRepository>()));
  sl.registerLazySingleton<GetPlayersUseCase>(() => GetPlayersUseCase(repository: sl<PlayerRepository>()));
  sl.registerLazySingleton<GetPlayersPerformanceUseCase>(() => GetPlayersPerformanceUseCase(repository: sl<PlayerRepository>()));

  // Feedback (if needed later)
  // sl.registerLazySingleton<ShotPredictionRepository>(() => ShotPredictionRepositoryImpl(sl<DioClient>()));
  // sl.registerLazySingleton<PredictShotUseCase>(() => PredictShotUseCase(sl<ShotPredictionRepository>()));
}
