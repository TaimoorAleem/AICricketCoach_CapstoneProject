class SignupReqParams {
  final String email;
  final String password;
  final String role;
  SignupReqParams({
    required this.email,
    required this.password,
    required this.role
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'role': role
    };
  }
}