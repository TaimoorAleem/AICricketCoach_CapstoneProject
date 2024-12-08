import 'dart:io';
import 'dart:typed_data';

import 'package:ai_cricket_coach/features/user_profile/presentation/bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/service_locator.dart';
import '../../domain/usecases/get_profile_picture.dart';
import '../../domain/usecases/get_user_profile.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileLoading());

  void getUserProfile() async {
    var returnedData = await sl<GetUserProfileUseCase>().call();
    returnedData.fold(
      (error) {
        emit(ProfileLoadingFailed(errorMessage: error));
      },
      (data) async {
        var userData = data;
        // if (data.pfpUrl == null){
        emit(ProfileLoaded(user: data));
        // }
        // else{
          // var profilePicturePath = await sl<GetProfilePictureUseCase>().call(params: userData.pfpUrl);
          // profilePicturePath.fold((error) {
          //   emit(ProfileLoadingFailed(errorMessage: error));
          // }, (data) async {
          //   emit(ProfileLoadedWithPicture(user: userData, profilePicturePath: data));
          // });
        // }

      },
    );
  }
}
