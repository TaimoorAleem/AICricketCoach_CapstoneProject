import 'package:ai_cricket_coach/features/authentication/data/models/reset_pw_params.dart';
import 'package:ai_cricket_coach/features/user_profile/data/models/EditProfileReqParams.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../resources/api_urls.dart';
import '../../../../resources/dio_client.dart';
import '../../../../resources/service_locator.dart';
import '../models/login_req_params.dart';
import '../models/signup_req_params.dart';
import '../models/update_fcmtoken_params.dart';

abstract class AuthService {
  Future<Either<String, Map<String, dynamic>>> signup(SignupReqParams params);
  Future<Either<String, Map<String, dynamic>>> login(LoginReqParams params);
  Future<Either<String, Map<String, dynamic>>> resetpassword(ResetPWParams params);
  Future<Either<String, Map<String, dynamic>>> createProfile(EditProfileReqParams params);
}

class AuthApiServiceImpl extends AuthService {

  @override
  Future<Either<String, Map<String, dynamic>>> signup(SignupReqParams params) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      String uid = userCredential.user!.uid;
      final updatedParams = SignupReqParams(email: params.email, password: uid, role: params.role);

      var response = await sl<DioClient>().post(
        ApiUrl.signup,
        data: updatedParams.toMap(),
      );

      String? idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        return const Left('Failed to generate ID token.');
      }

      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('uid', uid);
      sharedPreferences.setString('token', idToken);
      await saveFCMToken(response.data.uid);

      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? "Signup failed");
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> createProfile(EditProfileReqParams params) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrl.editProfile,
        data: params.toMap(),
      );
      debugPrint('meo1');
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? "Profile creation failed");
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> resetpassword(ResetPWParams params) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: params.email);
      return const Right({"message": "Password reset email sent"});
    } catch (e) {
      return Left("Reset password failed: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> login(LoginReqParams params) async {
    try {

      //Authenticate the user with Firebase
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      //Retrieve the ID token from the authenticated user
      String? idToken = await userCredential.user?.getIdToken();

      if (idToken == null) {
        return const Left('Failed to generate ID token.');
      }

      //Update the params with the ID token
      final updatedParams = LoginReqParams(email: params.email, password: idToken);

      //Send the updated params (with ID token) to the backend
      var response = await sl<DioClient>().post(
        ApiUrl.login,
        data: updatedParams.toMap(),
      );

      FirebaseMessaging messaging = FirebaseMessaging.instance;

      if (response.data['role'] == 'Player'){
        await messaging.subscribeToTopic('feedback-added-topic');
      }
      else if(response.data['role'] == 'Coach'){
        await messaging.subscribeToTopic('delivery-uploaded-topic');
      }

      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('token', idToken);
      await saveFCMToken(response.data['uid']);



      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    } catch (e) {
      return Left('An error occurred: $e');
    }
  }



  Future<void> saveFCMToken(String uid) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? fcm_token = await messaging.getToken();

    if(fcm_token != null) {
      UpdateFCMTokenParams params = UpdateFCMTokenParams(uid: uid, fcmToken: fcm_token);
      await sl<DioClient>().post(
          ApiUrl.editProfile,
          data: params.toMap()
      );
    }
  }

}