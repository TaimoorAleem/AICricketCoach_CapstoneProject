import 'package:ai_cricket_coach/features/user_profile/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/EditProfileReqParams.dart';

abstract class UserProfileRepo{
  Future<Either> getProfileInfo();
  Future<Either> editProfileInfo(EditProfileReqParams params);
  // Future<Either> getProfilePicture(String url);

}