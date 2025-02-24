import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../analytics/domain/entities/performance.dart';
import '../../domain/entities/player.dart';

class PlayerApiService {
  static const String baseUrl = "https://my-app-image-174827312206.us-central1.run.app";

  Future<List<Player>> fetchPlayers(String coachUid) async {
    final response = await http.get(Uri.parse("$baseUrl/get-players?uid=$coachUid"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        final playersMap = data["players"] as Map<String, dynamic>;
        return playersMap.values.map((p) => Player.fromJson(p)).toList();
      }
    }
    throw Exception("Failed to fetch players.");
  }

  Future<Map<String, List<Performance>>> fetchPlayersPerformance(List<String> playerUids) async {
    final response = await http.get(Uri.parse("https://my-app-image-174827312206.us-central1.run.app/get-performance-history?uid_list=${playerUids.toString()}"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        final playerData = data["data"] as Map<String, dynamic>;
        return playerData.map((uid, sessions) => MapEntry(uid, (sessions as List).map((s) => Performance.fromJson(s)).toList()));
      }
    }
    throw Exception("Failed to fetch players' performance.");
  }

}
