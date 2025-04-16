import '../../../sessions/domain/entities/delivery.dart';
import '../../../sessions/domain/entities/session.dart';

class SessionCache {
  static final SessionCache _instance = SessionCache._internal();
  final Map<String, Session> _sessionMap = {};
  String? _activeSessionId;
  String? _activePlayerId;

  SessionCache._internal();
  factory SessionCache() => _instance;

  Session? getActiveSession() => _activeSessionId == null ? null : _sessionMap[_activeSessionId!];
  String? get activeSessionId => _activeSessionId;
  bool hasActiveSession() => _activeSessionId != null;
  void setActiveSessionId(String sessionId) => _activeSessionId = sessionId;
  void clearActiveSession() => _activeSessionId = null;

  void setActivePlayerId(String uid) => _activePlayerId = uid;
  String? get activePlayerId => _activePlayerId;
  void clearActivePlayer() => _activePlayerId = null;

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

  void addDeliveryToSession({
    required String sessionId,
    required Delivery newDelivery,
  }) {
    final session = _sessionMap[sessionId];
    if (session != null) {
      session.deliveries.add(newDelivery);
    } else {
      _sessionMap[sessionId] = Session(
        sessionId: sessionId,
        date: DateTime.now().toIso8601String(),
        deliveries: [newDelivery],
        performance: {},
      );
    }
    _activeSessionId = sessionId;
  }

  void clear() {
    _sessionMap.clear();
    _activeSessionId = null;
    _activePlayerId = null;
  }
}
