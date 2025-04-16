import 'package:ai_cricket_coach/features/authentication/data/models/reset_pw_params.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../resources/service_locator.dart';
import '../../../user_profile/data/models/EditProfileReqParams.dart';
import '../../domain/repositories/auth_repo.dart';
import '../data_sources/auth_api_service.dart';
import '../models/login_req_params.dart';
import '../models/signup_req_params.dart';

class AuthRepoImpl extends AuthRepo {
  @override
  Future<Either> signup(SignupReqParams params) async {
    var data = await sl<AuthService>().signup(params);
    return data.fold((error) {
      return Left(error);
    }, (data) async {
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      return Right(data);
    });
  }

  @override
  Future<Either> createProfile(EditProfileReqParams params) async {
    var data = await sl<AuthService>().createProfile(params);
    debugPrint('meo2');
    return data.fold((error) {
      return Left(error);
    }, (data) async {
      return Right(data);
    });
  }

  @override
  Future<Either> resetpassword(ResetPWParams params) async {
    var data = await sl<AuthService>().resetpassword(params);
    return data.fold((error) {
      return Left(error);
    }, (data) async {
      return Right(data);
    });
  }

  @override
  Future<Either> login(LoginReqParams params) async {
    var data = await sl<AuthService>().login(params);
    return data.fold((error) {
      return Left(error);
    }, (data) async {
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('uid', data['uid']);
      sharedPreferences.setString('role', data['role']);
      debugPrint(sharedPreferences.getString('uid'));
      debugPrint(sharedPreferences.getString('role'));
      return Right(data);
    });
  }

  @override
  Future<bool> isAuthenticated() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      return true;
    } catch (e) {
      return false;
    }
  }
}