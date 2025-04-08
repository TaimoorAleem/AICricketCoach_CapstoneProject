import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../resources/api_urls.dart';
import '../../../../resources/dio_client.dart';
import '../../../home/data/data_sources/session_cache.dart';
import '../../../sessions/domain/entities/session.dart';

class SessionManager {
  static const String _activeSessionKey = 'active_session_id';

  /// Get the active session ID from local storage
  static Future<String?> getActiveSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeSessionKey);
  }

  /// Creates a new session and sets it as active in cache and shared prefs
  static Future<String> createSession() async {
    final dioClient = await DioClient.init();
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');

    if (uid == null) {
      throw Exception('User ID (uid) not found in SharedPreferences');
    }

    final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final response = await dioClient.post(
      ApiUrl.createSession,
      data: {
        "uid": uid,
        "date": formattedDate,
      },
    );

    if (response.statusCode != 200 || response.data == null) {
      throw Exception('Failed to create session. Server returned an invalid response.');
    }

    final sessionId = response.data['data']?['sessionId'];
    if (sessionId == null || sessionId is! String) {
      throw Exception('Session ID missing or invalid in response: ${response.data}');
    }

    // Save to SharedPreferences
    await prefs.setString(_activeSessionKey, sessionId);

    // Cache the new session locally
    SessionCache().storeSessions([
      Session(
        sessionId: sessionId,
        date: formattedDate,
        deliveries: [],
        performance: {},
      )
    ]);
    SessionCache().setActiveSessionId(sessionId);

    return sessionId;
  }

  /// Clears the locally stored active session ID
  static Future<void> clearActiveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeSessionKey);
    SessionCache().clearActiveSession();
  }

  /// Calls the API to trigger performance calculation
  static Future<void> calculatePerformance(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');

    if (uid == null) {
      throw Exception('User ID (uid) not found in SharedPreferences');
    }

    final dioClient = await DioClient.init();

    final response = await dioClient.get(
      ApiUrl.getPerformance,
      queryParameters: {
        "uid": uid,
        "sessionId": sessionId,
      },
    );

    if (response.statusCode != 200 || response.data == null) {
      throw Exception('Failed to get performance: ${response.data}');
    }

    final updatedPerformance = response.data['performance'] ?? {};
    final session = SessionCache().getSessionById(sessionId);
    if (session != null) {
      final updatedSession = session.copyWith(performance: updatedPerformance);
      SessionCache().storeSessions([updatedSession]);
    }

    // Clear active session status
    await clearActiveSession();
  }
}
