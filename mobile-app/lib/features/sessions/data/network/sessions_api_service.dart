import 'package:shared_preferences/shared_preferences.dart';
import '../../../../resources/dio_client.dart';

class SessionApiService {
  final DioClient dioClient;

  SessionApiService(this.dioClient);

  Future<Map<String, dynamic>> getSessions() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final uid = sharedPreferences.getString('uid');

    if (uid == null) {
      throw Exception("UID not found in SharedPreferences");
    }

    final response = await dioClient.get(
      'get-sessions',
      queryParameters: {'uid': uid},
    );
    return response.data as Map<String, dynamic>;
  }
}
