import 'package:ai_cricket_coach/features/user_profile/domain/repositories/user_profile_repo.dart';
import 'package:ai_cricket_coach/resources/user_mapper.dart';
import 'package:dartz/dartz.dart';

import '../../../../resources/service_locator.dart';
import '../data_sources/user_profile_service.dart';
import '../models/user.dart';

class UserProfileRepoImpl extends UserProfileRepo {
  @override
  Future<Either> getProfileInfo(String uid) async{
    var returnedData = await sl<UserProfileService>().getProfileInfo(uid);
    return returnedData.fold(
        (error){
          return Left(error);
        },
        (data){
          var user = UserMapper.toEntity(UserModel.fromJson(data['data']));
          return Right(user);
        }
    );
  }

}