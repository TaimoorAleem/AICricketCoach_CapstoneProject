import 'package:ai_cricket_coach/features/authentication/data/models/reset_pw_params.dart';
import 'package:ai_cricket_coach/features/user_profile/data/models/EditProfileReqParams.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/login_req_params.dart';
import '../../data/models/signup_req_params.dart';
abstract class AuthRepo {

  Future<Either> signup(SignupReqParams params);
  Future<Either> login(LoginReqParams params);
  Future<bool> isAuthenticated();
  Future<bool> logout();
  Future<Either> resetpassword(ResetPWParams params);
  Future<Either> createProfile(EditProfileReqParams params);
}