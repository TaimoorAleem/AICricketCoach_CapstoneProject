

class ResetPWParams {
  final String email;
  ResetPWParams({
    required this.email
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email
    };
  }
}