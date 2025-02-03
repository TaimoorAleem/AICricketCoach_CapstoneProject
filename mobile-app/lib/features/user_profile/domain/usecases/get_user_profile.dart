import 'package:dartz/dartz.dart';

import '../../../../resources/service_locator.dart';
import '../../../../resources/usecase.dart';
import '../repositories/user_profile_repo.dart';

class GetUserProfileUseCase extends UseCase<Either, dynamic> {

  @override
  Future<Either> call({params}) async {
    return await sl<UserProfileRepo>().getProfileInfo();
  }

}