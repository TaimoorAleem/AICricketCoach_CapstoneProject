import 'package:ai_cricket_coach/resources/api_urls.dart';
import 'package:ai_cricket_coach/resources/dio_client.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../resources/service_locator.dart';

abstract class UserProfileService{
  Future<Either> getProfileInfo();
}

class UserProfileServiceImpl extends UserProfileService {
  @override
  Future<Either> getProfileInfo() async {
    try {
      final SharedPreferences sharedPreferences = await SharedPreferences
          .getInstance();
      var uid = sharedPreferences.getString('uid');
      var response = await sl<DioClient>().get(
          ApiUrl.getUser,
          queryParameters: {"uid": uid}
      );

      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }
}