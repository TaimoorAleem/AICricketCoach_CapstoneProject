

class DeleteAccountReqParams {
  final String uid;
  final String password;
  DeleteAccountReqParams({
    required this.uid,
    required this.password
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'password': password,
    };
  }

}
