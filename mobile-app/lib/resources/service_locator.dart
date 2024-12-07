
import 'package:get_it/get_it.dart';
import 'package:wqeqwewq/features/authentication/domain/usecases/is_authenticated_usecase.dart';
import 'package:wqeqwewq/features/authentication/domain/usecases/login_usecase.dart';

import '../features/authentication/data/data_sources/auth_api_service.dart';
import '../features/authentication/data/repositories/auth_repo_impl.dart';
import '../features/authentication/domain/repositories/auth_repo.dart';
import '../features/authentication/domain/usecases/signup_usecase.dart';
import '../features/user_profile/data/data_sources/profile_api_service.dart';
import 'dio_client.dart';
final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<DioClient>(DioClient());


  // Services
  sl.registerSingleton<AuthService>(AuthApiServiceImpl());
  sl.registerSingleton<ProfileService>(ProfileApiServiceImpl());

  // Repostories
  sl.registerSingleton<AuthRepo>(AuthRepoImpl());

  // Usecases
  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<LoginUseCase>(LoginUseCase());
  sl.registerSingleton<IsAuthenticatedUseCase>(IsAuthenticatedUseCase());
}