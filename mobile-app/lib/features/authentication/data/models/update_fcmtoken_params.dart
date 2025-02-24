

class UpdateFCMTokenParams {
  final String uid;
  final String fcmToken;
  UpdateFCMTokenParams({
    required this.uid,
    required this.fcmToken
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'fcm_token':fcmToken
    };
  }
}