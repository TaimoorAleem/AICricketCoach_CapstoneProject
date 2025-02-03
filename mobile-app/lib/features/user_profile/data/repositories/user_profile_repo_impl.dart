
import 'package:ai_cricket_coach/features/user_profile/domain/repositories/user_profile_repo.dart';
import 'package:ai_cricket_coach/resources/user_mapper.dart';
import 'package:dartz/dartz.dart';

import '../../../../resources/service_locator.dart';
import '../data_sources/user_profile_service.dart';
import '../models/EditProfileReqParams.dart';
import '../models/delete_account_params.dart';
import '../models/user.dart';

class UserProfileRepoImpl extends UserProfileRepo {
  @override
  Future<Either> getProfileInfo() async{
    var returnedData = await sl<UserProfileService>().getProfileInfo();
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

  @override
  Future<Either> deleteAccount(DeleteAccountReqParams params) async{
    var returnedData = await sl<UserProfileService>().deleteAccount(params);
    return returnedData.fold(
            (error){
          return Left(error);
        },
            (data){
          return Right(data);
        }
    );
  }

  @override
  Future<Either> editProfileInfo(EditProfileReqParams params) async{
    var returnedData = await sl<UserProfileService>().editProfileInfo(params);
    return returnedData.fold(
            (error){
          return Left(error);
        },
            (data){
          var user = UserMapper.toEntity(UserModel.fromJson(data['user']));
          return Right(user);
        }
    );
  }

// @override
// Future<Either> getProfilePicture(String url) async { // New method
//   var returnedData = await sl<UserProfileService>().getProfilePicture(url);
//   return returnedData.fold(
//         (error) => Left(error),
//         (data) async {
//           final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//           sharedPreferences.setString('pfpPath', data);
//       return Right(data);
//     },
//   );
// }


}