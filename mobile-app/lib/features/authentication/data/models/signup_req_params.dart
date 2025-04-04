

import 'package:ai_cricket_coach/features/user_profile/data/models/role_enum.dart';

class SignupReqParams {
  final String email;
  final String password;
  final String role;
  final String firstName;
  final String lastName;
  SignupReqParams({
    required this.email,
    required this.password,
    required this.role,
    required this.firstName,
    required this.lastName
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'role': role,
      'firstName': firstName,
      'lastName': lastName
    };
  }
}