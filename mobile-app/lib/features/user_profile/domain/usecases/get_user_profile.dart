import 'package:ai_cricket_coach/features/user_profile/data/repositories/user_profile_repo_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../resources/service_locator.dart';
import '../../../../resources/usecase.dart';
import '../repositories/user_profile_repo.dart';

class GetUserProfileUseCase extends UseCase<Either, dynamic> {

  @override
  Future<Either> call({params}) async {
    // final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // var uid = sharedPreferences.getString('uid');
    return await sl<UserProfileRepo>().getProfileInfo();
  }

}