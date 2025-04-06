import '../features/sessions/domain/entities/delivery.dart';
import '../features/sessions/domain/entities/session.dart';

class SessionCache {
  static final SessionCache _instance = SessionCache._internal();
  final Map<String, Session> _sessionMap = {};
  String? _activeSessionId; // 🟡 Track the active session ID

  SessionCache._internal();

  factory SessionCache() => _instance;

  // Active session methods
  Session? getActiveSession() {
    if (_activeSessionId == null) return null;
    return _sessionMap[_activeSessionId];
  }

  void setActiveSessionId(String sessionId) {
    _activeSessionId = sessionId;
  }

  String? get activeSessionId => _activeSessionId;

  void clearActiveSession() {
    _activeSessionId = null;
  }

  bool hasActiveSession() => _activeSessionId != null;

  // Session data handling
  void storeSessions(List<Session> sessions) {
    _sessionMap.clear();
    for (var session in sessions) {
      _sessionMap[session.sessionId] = session;
    }
  }

  List<Session> getAllSessions() => _sessionMap.values.toList();

  Session? getSessionById(String sessionId) => _sessionMap[sessionId];

  Delivery? getDeliveryById(String sessionId, String deliveryId) {
    final session = _sessionMap[sessionId];
    if (session == null) return null;
    try {
      return session.deliveries.firstWhere((d) => d.deliveryId == deliveryId);
    } catch (_) {
      return null;
    }
  }

  // Update delivery feedback
  void updateDeliveryFeedback({
    required String sessionId,
    required String deliveryId,
    required double rating,
    required String feedback,
  }) {
    final session = _sessionMap[sessionId];
    if (session == null) return;

    final index = session.deliveries.indexWhere((d) => d.deliveryId == deliveryId);
    if (index == -1) return;

    final updatedDelivery = session.deliveries[index].copyWith(
      battingRating: rating,
      feedback: feedback,
    );

    session.deliveries[index] = updatedDelivery;
  }

  // Add delivery to a session
  void addDeliveryToSession({
    required String sessionId,
    required Delivery newDelivery,
  }) {
    final session = _sessionMap[sessionId];
    if (session == null) return;

    session.deliveries.add(newDelivery);
  }

  void clear() {
    _sessionMap.clear();
    _activeSessionId = null;
  }
}
