import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../models/session_model.dart';

class SessionsLocalDataSource {
  final CacheManager cacheManager;

  SessionsLocalDataSource({required this.cacheManager});

  Future<void> cacheSessions(List<SessionModel> sessions) async {
    final sessionJsonList = jsonEncode(sessions.map((session) => session.toJson()).toList());
    final sessionBytes = Uint8List.fromList(sessionJsonList.codeUnits);
    await cacheManager.putFile('cached_sessions', sessionBytes);
  }

  Future<List<SessionModel>> getCachedSessions() async {
    final fileInfo = await cacheManager.getFileFromCache('cached_sessions');
    if (fileInfo == null) {
      throw Exception('No cached sessions found');
    }

    final fileContent = await fileInfo.file.readAsString();
    final List<dynamic> sessionJsonList = jsonDecode(fileContent);
    return sessionJsonList.map((json) => SessionModel.fromJson(json)).toList();
  }

  Future<bool> hasCachedSessions() async {
    final fileInfo = await cacheManager.getFileFromCache('cached_sessions');
    return fileInfo != null;
  }
}