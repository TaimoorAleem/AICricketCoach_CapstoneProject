
import 'package:ai_cricket_coach/features/user_profile/domain/entities/user_entity.dart';

abstract class ProfileState{}

class ProfileLoading extends ProfileState{}

class ProfileLoaded extends ProfileState{
  final UserEntity user;
  ProfileLoaded({required this.user});
}
// class ProfileLoadedWithPicture extends ProfileState{
//   final UserEntity user;
//   final String profilePicturePath;
//   ProfileLoadedWithPicture({required this.user, required this.profilePicturePath});
// }

class ProfileLoadingFailed extends ProfileState{
  final String errorMessage;
  ProfileLoadingFailed({required this.errorMessage});
}