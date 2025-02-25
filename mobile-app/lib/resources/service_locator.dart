import 'package:ai_cricket_coach/features/authentication/domain/usecases/create_profile.dart';
import 'package:ai_cricket_coach/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:ai_cricket_coach/features/authentication/domain/usecases/send_code_usecase.dart';
import 'package:ai_cricket_coach/features/user_profile/data/data_sources/user_profile_service.dart';
import 'package:ai_cricket_coach/features/user_profile/data/repositories/user_profile_repo_impl.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/repositories/user_profile_repo.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/usecases/delete_account_usecase.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/usecases/edit_pfp_usecase.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/usecases/edit_profile.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/usecases/get_user_profile.dart';
import 'package:get_it/get_it.dart';
import '../features/authentication/presentation/bloc/AuthCubit.dart';
import '../features/coaches/data/data_sources/player_api_service.dart';
import '../features/coaches/data/repositories/player_repository_impl.dart';
import '../features/coaches/domain/repositories/player_repository.dart';
import '../features/coaches/domain/usecases/get_players_performance_usecase.dart';
import '../features/coaches/domain/usecases/get_players_usecase.dart';
import '../features/feedback/data/repositories/shot_prediction_repository_impl.dart';
import '../features/feedback/domain/repositories/shot_prediction_repository.dart';
import '../features/feedback/domain/usecases/predict_shot_usecase.dart';
import 'dio_client.dart';

// Authentication
import '../features/authentication/data/data_sources/auth_api_service.dart';
import '../features/authentication/data/repositories/auth_repo_impl.dart';
import '../features/authentication/domain/repositories/auth_repo.dart';
import '../features/authentication/domain/usecases/is_authenticated_usecase.dart';
import '../features/authentication/domain/usecases/login_usecase.dart';
import '../features/authentication/domain/usecases/signup_usecase.dart';

// User Profile
import '../features/user_profile/domain/usecases/get_profile_picture.dart';

// Sessions
import '../features/sessions/data/data_sources/sessions_api_service.dart';
import '../features/sessions/data/repositories/session_repository_impl.dart';
import '../features/sessions/domain/repositories/session_repository.dart';
import '../features/sessions/domain/usecases/get_sessions_usecase.dart';

// Analytics (Performance Tracking)
import '../features/analytics/data/network/performance_api_service.dart';
import '../features/analytics/data/repositories/performance_repository_impl.dart';
import '../features/analytics/domain/repositories/performance_repository.dart';
import '../features/analytics/domain/usecases/get_performance_history_usecase.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // **Networking**
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // **API Services**
  sl.registerLazySingleton<AuthService>(() => AuthApiServiceImpl());
  sl.registerLazySingleton<UserProfileService>(() => UserProfileServiceImpl());
  sl.registerLazySingleton<SessionApiService>(() => SessionApiService(sl<DioClient>()));
  sl.registerLazySingleton<PerformanceApiService>(() => PerformanceApiService(sl<DioClient>()));
  sl.registerLazySingleton<ShotPredictionRepository>(() => ShotPredictionRepositoryImpl(sl<DioClient>()));
  sl.registerLazySingleton<PlayerApiService>(() => PlayerApiService());

  // **Repositories**
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl());
  sl.registerLazySingleton<UserProfileRepo>(() => UserProfileRepoImpl());
  sl.registerLazySingleton<SessionsRepository>(() => SessionsRepositoryImpl(apiService: sl<SessionApiService>()));
  sl.registerLazySingleton<PerformanceRepository>(() => PerformanceRepositoryImpl(apiService: sl<PerformanceApiService>()));
  sl.registerLazySingleton<PlayerRepository>(() => PlayerRepositoryImpl(apiService: sl<PlayerApiService>()));

  // **Bloc / Cubit**
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit());

  // **Use Cases** (No Duplicates)
  if (!sl.isRegistered<SignupUseCase>()) {
    sl.registerLazySingleton<SignupUseCase>(() => SignupUseCase());
  }
  if (!sl.isRegistered<LoginUseCase>()) {
    sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase());
  }
  if (!sl.isRegistered<LogOutUseCase>()) {
    sl.registerLazySingleton<LogOutUseCase>(() => LogOutUseCase());
  }
  if (!sl.isRegistered<CreateProfileUseCase>()) {
    sl.registerLazySingleton<CreateProfileUseCase>(() => CreateProfileUseCase());
  }
  if (!sl.isRegistered<EditPFPUseCase>()) {
    sl.registerLazySingleton<EditPFPUseCase>(() => EditPFPUseCase());
  }
  if (!sl.isRegistered<SendCodeUseCase>()) {
    sl.registerLazySingleton<SendCodeUseCase>(() => SendCodeUseCase());
  }
  if (!sl.isRegistered<IsAuthenticatedUseCase>()) {
    sl.registerLazySingleton<IsAuthenticatedUseCase>(() => IsAuthenticatedUseCase());
  }
  if (!sl.isRegistered<GetUserProfileUseCase>()) {
    sl.registerLazySingleton<GetUserProfileUseCase>(() => GetUserProfileUseCase());
  }
  if (!sl.isRegistered<GetProfilePictureUseCase>()) {
    sl.registerLazySingleton<GetProfilePictureUseCase>(() => GetProfilePictureUseCase());
  }
  if (!sl.isRegistered<EditProfileUseCase>()) {
    sl.registerLazySingleton<EditProfileUseCase>(() => EditProfileUseCase());
  }
  if (!sl.isRegistered<DeleteAccountUseCase>()) {
    sl.registerLazySingleton<DeleteAccountUseCase>(() => DeleteAccountUseCase());
  }
  if (!sl.isRegistered<GetSessionsUseCase>()) {
    sl.registerLazySingleton<GetSessionsUseCase>(() => GetSessionsUseCase(repository: sl<SessionsRepository>()));
  }
  if (!sl.isRegistered<GetPerformanceHistoryUseCase>()) {
    sl.registerLazySingleton<GetPerformanceHistoryUseCase>(() => GetPerformanceHistoryUseCase(repository: sl<PerformanceRepository>()));
  }
  if (!sl.isRegistered<GetPlayersUseCase>()) {
    sl.registerLazySingleton<GetPlayersUseCase>(() => GetPlayersUseCase(repository: sl<PlayerRepository>()));
  }
  if (!sl.isRegistered<GetPlayersPerformanceUseCase>()) {
    sl.registerLazySingleton<GetPlayersPerformanceUseCase>(() => GetPlayersPerformanceUseCase(repository: sl<PlayerRepository>()));
  }
  if (!sl.isRegistered<PredictShotUseCase>()) {
    sl.registerLazySingleton(() => PredictShotUseCase(sl<ShotPredictionRepository>()));
  }
}
