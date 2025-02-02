
import 'package:ai_cricket_coach/features/authentication/domain/usecases/send_code_usecase.dart';
import 'package:ai_cricket_coach/features/user_profile/data/data_sources/user_profile_service.dart';
import 'package:ai_cricket_coach/features/user_profile/data/repositories/user_profile_repo_impl.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/repositories/user_profile_repo.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/usecases/edit_profile.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/usecases/get_user_profile.dart';
import 'package:get_it/get_it.dart';
import '../features/authentication/data/data_sources/auth_api_service.dart';
import '../features/authentication/data/repositories/auth_repo_impl.dart';
import '../features/authentication/domain/repositories/auth_repo.dart';
import '../features/authentication/domain/usecases/is_authenticated_usecase.dart';
import '../features/authentication/domain/usecases/login_usecase.dart';
import '../features/authentication/domain/usecases/signup_usecase.dart';
import '../features/user_profile/domain/usecases/get_profile_picture.dart';
import 'dio_client.dart';
final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<DioClient>(DioClient());


  // Services
  sl.registerSingleton<AuthService>(AuthApiServiceImpl());
  sl.registerSingleton<UserProfileService>(UserProfileServiceImpl());

  // Repostories
  sl.registerSingleton<AuthRepo>(AuthRepoImpl());
  sl.registerSingleton<UserProfileRepo>(UserProfileRepoImpl());

  // Usecases
  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<LoginUseCase>(LoginUseCase());
  sl.registerSingleton<SendCodeUseCase>(SendCodeUseCase());
  sl.registerSingleton<IsAuthenticatedUseCase>(IsAuthenticatedUseCase());
  sl.registerSingleton<GetUserProfileUseCase>(GetUserProfileUseCase());
  sl.registerSingleton<EditProfileUseCase>(EditProfileUseCase());
  //sl.registerSingleton<GetProfilePictureUseCase>(GetProfilePictureUseCase());
}
