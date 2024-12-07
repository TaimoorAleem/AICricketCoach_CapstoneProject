import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:wqeqwewq/features/authentication/data/models/login_req_params.dart';

import '../../../../resources/api_urls.dart';
import '../../../../resources/dio_client.dart';
import '../../../../resources/service_locator.dart';
import '../models/signup_req_params.dart';

abstract class AuthService {

  Future<Either> signup(SignupReqParams params);
  Future<Either> login(LoginReqParams params);
}


class AuthApiServiceImpl extends AuthService {


  @override
  Future<Either> signup(SignupReqParams params) async {
    try {

      var response = await sl<DioClient>().post(
          ApiUrl.signup,
          data: params.toMap()
      );
      return Right(response.data);

    } on DioException catch(e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> login(LoginReqParams params) async {
    try {

      var response = await sl<DioClient>().post(
          ApiUrl.login,
          data: params.toMap()
      );
      return Right(response.data);

    } on DioException catch(e) {
      return Left(e.response!.data['message']);
    }
  }


}