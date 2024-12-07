import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wqeqwewq/features/authentication/data/models/login_req_params.dart';

import '../../../../resources/service_locator.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../../authentication/data/data_sources/auth_api_service.dart';
import '../models/signup_req_params.dart';

class AuthRepoImpl extends AuthRepo {


  @override
  Future<Either> signup(SignupReqParams params) async {
    var data = await sl<AuthService>().signup(params);
    return data.fold(
            (error) {
          return Left(error);
        },
            (data) async {
          final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString('uid',data['uid']);
          return Right(data);
        }
    );
  }

  @override
  Future<Either> login(LoginReqParams params) async {
    var data = await sl<AuthService>().login(params);
    return data.fold(
            (error) {
          return Left(error);
        },
            (data) async {
          final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString('uid',data['uid']);
          return Right(data);
        }
    );
  }

  @override
  Future<bool> isAuthenticated() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }

}