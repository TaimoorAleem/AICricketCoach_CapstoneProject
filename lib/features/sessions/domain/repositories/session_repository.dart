import '../entities/session.dart';

abstract class SessionRepository {
  /// Retrieves all sessions for the current user.
  /// Returns a `DataState` with either a list of `Session` objects (success) or an error (failure).
  Future<List<SessionEntity>> getSessions();
  Future<List<SessionEntity>> getSessionsByPage({int limit, String? startAfterId});

  /// Retrieves a specific session by its ID.
  /// Returns a `DataState` with the `Session` object (success) or an error (failure).
  Future<SessionEntity> getSessionById(String sessionId);

  /// Creates a new session and stores it in the database.
  /// Accepts a `Session` object as input and returns a `DataState` with the created session's ID (success) or an error (failure).
  Future<String> createSession(SessionEntity session);

  /// Updates an existing session in the database.
  /// Accepts a `Session` object and returns a `DataState` with a boolean indicating success (true) or failure (false).
  Future<bool> updateSession(SessionEntity session);

  /// Deletes a session by its ID.
  /// Accepts the session ID as input and returns a `DataState` with a boolean indicating success (true) or failure (false).
  Future<bool> deleteSession(String sessionId);
}