import 'package:ai_cricket_coach/features/user_profile/data/repositories/user_profile_repo_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../resources/service_locator.dart';
import '../../../../resources/usecase.dart';
import '../repositories/user_profile_repo.dart';

class EditProfileUseCase extends UseCase<Either, dynamic> {

  @override
  Future<Either> call({params}) async {
    debugPrint("made it to usecase");
    return await sl<UserProfileRepo>().editProfileInfo(params);
  }

}