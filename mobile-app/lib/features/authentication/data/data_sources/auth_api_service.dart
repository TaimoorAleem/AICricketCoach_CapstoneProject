import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../resources/api_urls.dart';
import '../../../../resources/dio_client.dart';
import '../../../../resources/service_locator.dart';
import '../models/login_req_params.dart';
import '../models/signup_req_params.dart';

abstract class AuthService {

  Future<Either> signup(SignupReqParams params);
  Future<Either> login(LoginReqParams params);
}


class AuthApiServiceImpl extends AuthService {


  @override
  Future<Either> signup(SignupReqParams params) async {
    try {

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: params.email,
          password: params.password
      );

      String uid = userCredential.user!.uid;

      final updatedParams = SignupReqParams(email: params.email, password: uid);

      var response = await sl<DioClient>().post(
          ApiUrl.signup,
          data: updatedParams.toMap()
      );
      return Right(response.data);

    } on DioException catch(e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> login(LoginReqParams params) async {
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

      return Right(response.data);

    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    } catch (e) {
      return Left('An error occurred: $e');
    }
  }



}