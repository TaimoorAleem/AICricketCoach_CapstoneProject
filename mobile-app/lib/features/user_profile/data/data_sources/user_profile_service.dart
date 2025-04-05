import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ai_cricket_coach/features/user_profile/data/models/EditProfileReqParams.dart';
import 'package:ai_cricket_coach/resources/api_urls.dart';
import 'package:ai_cricket_coach/resources/dio_client.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../resources/display_message.dart';
import '../../../../resources/service_locator.dart';
import '../../domain/entities/user_entity.dart';
import '../models/delete_account_params.dart';

abstract class UserProfileService {
  Future<Either> getProfileInfo();
  Future<Either> editProfileInfo(EditProfileReqParams params);
  Future<Either> deleteAccount(DeleteAccountReqParams params);
  Future<Either> getProfilePicture(String url);
  Future<Either> editProfilePicture(String path);
}

class UserProfileServiceImpl extends UserProfileService {
  @override
  Future<Either> getProfileInfo() async {
    try {
      final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      var uid = sharedPreferences.getString('uid');
      var response = await sl<DioClient>()
          .get(ApiUrl.getUser, queryParameters: {"uid": uid});

      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> deleteAccount(DeleteAccountReqParams params) async {
    try {
      var userData = await sl<DioClient>()
          .get(ApiUrl.getUser, queryParameters: {"uid": params.uid});

      var email = userData.data['data']['email'];

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: params.password,
      );

      //Retrieve the ID token from the authenticated user
      String? idToken = await userCredential.user?.getIdToken();

      if (idToken == null) {
        return const Left('Failed to generate ID token.');
      }
      final updatedParams =
      DeleteAccountReqParams(uid: params.uid, password: idToken);

      var response = await sl<DioClient>()
          .post(ApiUrl.deleteAccount, data: updatedParams.toMap());

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> editProfileInfo(EditProfileReqParams params) async {
    try {
      var response = await sl<DioClient>().post(ApiUrl.editProfile, data: params.toMap());
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either<String, String>> getProfilePicture(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        imageCache.clear();
        final bytes = response.bodyBytes; // Image bytes

        // Get the application documents directory
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/pfp.jpg';

        // Save the image as a file
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        // Return the file path on success
        return Right(filePath);
      } else {
        return Left(
            'Failed to download image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Failed to download image: $e');
    }
  }

  @override
  Future<Either> editProfilePicture(String path) async {
    try {
      final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      var uid = sharedPreferences.getString('uid');
      FormData formData = FormData.fromMap({
        "uid": uid, // Send UID as text
        "file": await MultipartFile.fromFile(path,
            filename: "profile.jpg"), // Image file
      });

      var response =
      await sl<DioClient>().post(ApiUrl.editPfp, data: formData);
      if (response.statusCode == 200) {
        sharedPreferences.setString('pfpUrl', response.data['url']);
        return Right(response.data['url']);
      } else {
        return const Left('Failed to download image');
      }
    } catch (e) {
      return Left('Failed to download image: $e');
    }
  }
}