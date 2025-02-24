import 'package:dartz/dartz.dart';

import '../../data/models/EditProfileReqParams.dart';
import '../../data/models/delete_account_params.dart';

abstract class UserProfileRepo{
  Future<Either> getProfileInfo();
  Future<Either> editProfileInfo(EditProfileReqParams params);
  Future<Either> deleteAccount(DeleteAccountReqParams params);
  Future<Either> getProfilePicture(String url);
  Future<Either> editPfp(String path);

}