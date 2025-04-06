import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../resources/api_urls.dart';
import '../../../../resources/dio_client.dart';

class SessionManager {
  static const String _activeSessionKey = 'active_session_id';

  /// Check if there's an active session
  static Future<String?> getActiveSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeSessionKey);
  }

  /// Creates a new session and stores its ID locally
  static Future<String> createSession() async {
    final dioClient = await DioClient.init();
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');

    if (uid == null) throw Exception('User ID (uid) not found');

    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final response = await dioClient.post(
      ApiUrl.createSession,
      data: {
        "uid": uid,
        "date": formattedDate,
      },
    );

    if (response.statusCode != 200 || response.data['status'] != 'success') {
      throw Exception('Failed to create session: ${response.data}');
    }

    final sessionId = response.data['sessionId'];
    await prefs.setString(_activeSessionKey, sessionId);

    return sessionId;
  }

  static Future<void> clearActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeSessionKey);
  }
}
