import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/session_repository.dart';
import '../models/session_model.dart';

class SessionRepositoryImpl implements SessionRepository {
  final FirebaseFirestore _firestore;

  SessionRepositoryImpl(this._firestore);

  @override
  Future<List<SessionEntity>> getSessions() async {
    try {
      final snapshot = await _firestore.collection('sessions').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return SessionModel.fromJson(data, doc.id);
      }).toList();
    } on FirebaseException catch (e) {
      // Log the error or handle it further up the call stack
      print('FirebaseException: ${e.message}');
      rethrow; // Rethrow to let the caller handle it
    }
  }

  @override
  Future<SessionEntity> getSessionById(String sessionId) async {
    try {
      final doc = await _firestore.collection('sessions').doc(sessionId).get();
      if (!doc.exists) {
        throw Exception('Session not found');
      }
      return SessionModel.fromJson(doc.data()!, doc.id);
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<List<SessionEntity>> getSessionsByPage({int limit = 10, String? startAfterId}) async {
    try {
      Query query = _firestore.collection('sessions').orderBy('dateTime').limit(limit);

      // If a starting point is provided, use it for pagination
      if (startAfterId != null) {
        final startAfterDoc = await _firestore.collection('sessions').doc(startAfterId).get();
        if (startAfterDoc.exists) {
          query = query.startAfterDocument(startAfterDoc);
        } else {
          throw Exception('Start after document not found');
        }
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>; // Explicitly cast to Map<String, dynamic>
        return SessionModel.fromJson(data, doc.id);
      }).toList();
    } on FirebaseException catch (e) {
      print('FirebaseException in getSessionsByPage: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<String> createSession(SessionEntity session) async {
    try {
      final docRef = await _firestore.collection('sessions').add(SessionModel.fromEntity(session).toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<bool> updateSession(SessionEntity session) async {
    try {
      await _firestore.collection('sessions').doc(session.id).update(SessionModel.fromEntity(session).toJson());
      return true;
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      return false;
    }
  }

  @override
  Future<bool> deleteSession(String sessionId) async {
    try {
      await _firestore.collection('sessions').doc(sessionId).delete();
      return true;
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      return false;
    }
  }
}