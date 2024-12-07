import 'package:dartz/dartz.dart';

import '../../../authentication/data/models/login_req_params.dart';
import '../../data/models/signup_req_params.dart';

abstract class AuthRepo {

  Future<Either> signup(SignupReqParams params);
  Future<Either> login(LoginReqParams params);
  Future<bool> isAuthenticated();
}