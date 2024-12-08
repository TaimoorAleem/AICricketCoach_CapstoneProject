import 'package:ai_cricket_coach/features/user_profile/domain/repositories/user_profile_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../resources/service_locator.dart';
import '../data_sources/user_profile_service.dart';

class UserProfileRepoImpl extends UserProfileRepo {
  @override
  Future<Either> getProfileInfo() async{
    var returnedData = await sl<UserProfileService>().getProfileInfo();
    return returnedData.fold(
        (error){
          return Left(error);
        },
        (data){

        }
    )
  }

}