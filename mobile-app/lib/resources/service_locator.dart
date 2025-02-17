import 'package:ai_cricket_coach/features/user_profile/data/data_sources/user_profile_service.dart';
import 'package:ai_cricket_coach/features/user_profile/data/repositories/user_profile_repo_impl.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/repositories/user_profile_repo.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/usecases/delete_account_usecase.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/usecases/edit_pfp_usecase.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/usecases/edit_profile.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/usecases/get_user_profile.dart';
import 'package:get_it/get_it.dart';
import 'dio_client.dart';

final sl = GetIt.instance;

void setupServiceLocator() {

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


}
