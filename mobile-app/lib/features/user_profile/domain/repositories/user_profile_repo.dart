import 'package:dartz/dartz.dart';

abstract class UserProfileRepo{
  Future<Either> getProfileInfo(String uid);
}