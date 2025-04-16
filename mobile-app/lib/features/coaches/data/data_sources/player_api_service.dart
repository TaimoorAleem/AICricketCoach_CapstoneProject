import 'dart:convert';
import 'package:dio/dio.dart';

class PlayerApiService {
  final Dio dio;

  PlayerApiService({required this.dio});

  Future<Map<String, dynamic>> fetchPlayers(String coachUid) async {
    final url = 'https://aicc-gateway2-28bbo1fy.uc.gateway.dev/coaches/get-players?uid=$coachUid';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return response.data['players'] as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load players');
      }
    } catch (e) {
      throw Exception('Error fetching players: $e');
    }
  }
}
