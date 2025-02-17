import 'package:get_it/get_it.dart';
import '../features/analytics/presentation/bloc/AuthCubit.dart';
import 'dio_client.dart';

// Authentication
import '../features/authentication/data/data_sources/auth_api_service.dart';
import '../features/authentication/data/repositories/auth_repo_impl.dart';
import '../features/authentication/domain/repositories/auth_repo.dart';
import '../features/authentication/domain/usecases/is_authenticated_usecase.dart';
import '../features/authentication/domain/usecases/login_usecase.dart';
import '../features/authentication/domain/usecases/signup_usecase.dart';
import '../features/authentication/domain/usecases/send_code_usecase.dart';

// User Profile
import '../features/user_profile/data/data_sources/user_profile_service.dart';
import '../features/user_profile/data/repositories/user_profile_repo_impl.dart';
import '../features/user_profile/domain/repositories/user_profile_repo.dart';
import '../features/user_profile/domain/usecases/get_user_profile.dart';
import '../features/user_profile/domain/usecases/edit_profile.dart';
import '../features/user_profile/domain/usecases/delete_account_usecase.dart';
import '../features/user_profile/domain/usecases/edit_pfp_usecase.dart';
import '../features/user_profile/domain/usecases/get_profile_picture.dart';

// Sessions
import '../features/sessions/data/network/sessions_api_service.dart';
import '../features/sessions/data/repositories/session_repository_impl.dart';
import '../features/sessions/domain/repositories/session_repository.dart';
import '../features/sessions/domain/usecases/get_sessions_usecase.dart';

// Analytics (Performance Tracking)
import '../features/analytics/data/network/performance_api_service.dart';
import '../features/analytics/data/repositories/performance_repository_impl.dart';
import '../features/analytics/domain/repositories/performance_repository.dart';
import '../features/analytics/domain/usecases/get_performance_history_usecase.dart';

// Feedback (Shot Recommendation)
import '../features/feedback/data/data_sources/api_service.dart';
import '../features/feedback/data/repositories/shot_repository_impl.dart';
import '../features/feedback/domain/repositories/shot_repository.dart';
import '../features/feedback/domain/usecases/predict_shot.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // **Networking**
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // **API Services**
  sl.registerLazySingleton<AuthService>(() => AuthApiServiceImpl());
  sl.registerLazySingleton<UserProfileService>(() => UserProfileServiceImpl());
  sl.registerSingleton<SessionApiService>(SessionApiService(sl<DioClient>()));
  sl.registerSingleton<PerformanceApiService>(PerformanceApiService(sl<DioClient>()));
  sl.registerSingleton<ApiService>(ApiService('http://10.0.2.2:5000')); // Flask API for shot predictions

  // **Repositories**
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl());
  sl.registerLazySingleton<UserProfileRepo>(() => UserProfileRepoImpl());
  sl.registerSingleton<SessionsRepository>(
    SessionsRepositoryImpl(apiService: sl<SessionApiService>()),
  );
  sl.registerSingleton<PerformanceRepository>(
    PerformanceRepositoryImpl(apiService: sl<PerformanceApiService>()),
  );
  sl.registerSingleton<ShotRepository>(ShotRepositoryImpl(sl<ApiService>()));

  // Bloc / Cubit
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit());

  // **Use Cases**
  sl.registerLazySingleton<SignupUseCase>(() => SignupUseCase());
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase());
  sl.registerLazySingleton<IsAuthenticatedUseCase>(() => IsAuthenticatedUseCase());
  sl.registerLazySingleton<GetUserProfileUseCase>(() => GetUserProfileUseCase());
  sl.registerLazySingleton<EditProfileUseCase>(() => EditProfileUseCase());
  sl.registerSingleton<GetProfilePictureUseCase>(GetProfilePictureUseCase());
  sl.registerLazySingleton<EditPFPUseCase>(() => EditPFPUseCase());
  sl.registerLazySingleton<SendCodeUseCase>(() => SendCodeUseCase());
  sl.registerLazySingleton<DeleteAccountUseCase>(() => DeleteAccountUseCase());

  sl.registerSingleton<GetSessionsUseCase>(
    GetSessionsUseCase(repository: sl<SessionsRepository>()),
  );

  sl.registerSingleton<GetPerformanceHistoryUseCase>(
    GetPerformanceHistoryUseCase(repository: sl<PerformanceRepository>()),
  );

  sl.registerSingleton<PredictShot>(
    PredictShot(sl<ShotRepository>()),
  );
}