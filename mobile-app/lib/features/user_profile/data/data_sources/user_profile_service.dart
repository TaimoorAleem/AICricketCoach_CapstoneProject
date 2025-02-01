import 'dart:io';

import 'package:ai_cricket_coach/features/user_profile/data/models/EditProfileReqParams.dart';
import 'package:ai_cricket_coach/resources/api_urls.dart';
import 'package:ai_cricket_coach/resources/dio_client.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../resources/service_locator.dart';
import '../../domain/entities/user_entity.dart';

abstract class UserProfileService{
  Future<Either> getProfileInfo();
  Future<Either> editProfileInfo(EditProfileReqParams params);
  // Future<Either> getProfilePicture(String url);
}

class UserProfileServiceImpl extends UserProfileService {

  @override
  Future<Either> getProfileInfo() async {
    try {
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var uid = sharedPreferences.getString('uid');
      var response = await sl<DioClient>().get(
          ApiUrl.getUser,
          queryParameters: {"uid": uid}
      );

      return Right(response.data);
    }

    on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> editProfileInfo(EditProfileReqParams params) async{
    try {

      var response = await sl<DioClient>().post(
          ApiUrl.editProfile,
          data: params.toMap()
      );

      return Right(response.data);
    }

    on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  // @override
  // Future<Either> getProfilePicture(String url) async { // New method
  //   try {
  //     var response = await sl<DioClient>().get(
  //       ApiUrl.getProfilePicture,
  //       queryParameters: {"url" : url}
  //     );
  //     final bytes = response.data; // Image bytes
  //     final directory = await getApplicationDocumentsDirectory();
  //     final filePath = '${directory.path}/pfp.jpg'; // Save file with the proper path
  //
  //     final file = File(filePath);
  //     await file.writeAsBytes(bytes);
  //     return Right(filePath); // Return metadata or image file
  //   } on DioException catch (e) {
  //     return Left(e.response!.data['message']);
  //   }
  // }

}