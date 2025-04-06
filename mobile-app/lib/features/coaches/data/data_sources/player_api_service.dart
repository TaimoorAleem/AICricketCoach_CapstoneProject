import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../resources/api_urls.dart';
import '../../../../resources/dio_client.dart';
import '../../../analytics/domain/entities/performance.dart';
import '../../domain/entities/player.dart';

abstract class PlayerService {
  Future<Either<String, List<Player>>> fetchPlayers(String coachUid);
  Future<Either<String, Map<String, List<Performance>>>> fetchPlayersPerformance(List<String> playerUids);
}

class PlayerApiService implements PlayerService {
  final DioClient dioClient;

  PlayerApiService(this.dioClient);

  @override
  Future<Either<String, List<Player>>> fetchPlayers(String coachUid) async {
    try {
      final response = await dioClient.get(
        ApiUrl.getPlayers,
        queryParameters: {'uid': coachUid},
      );

      final playersMap = response.data['players'] as Map<String, dynamic>;
      final players = playersMap.values.map((p) => Player.fromJson(p)).toList();
      return Right(players);
    } on DioException catch (e) {
      return Left(e.response?.data?['message'] ?? 'Failed to fetch players.');
    } catch (e) {
      return Left('An unexpected error occurred: $e');
    }
  }

  @override
  Future<Either<String, Map<String, List<Performance>>>> fetchPlayersPerformance(List<String> playerUids) async {
    try {
      final response = await dioClient.get(
        ApiUrl.getPerformance,
        queryParameters: {'uid_list': jsonEncode(playerUids)},
      );

      final playerData = response.data['data'] as Map<String, dynamic>;
      final mapped = playerData.map((uid, sessions) => MapEntry(
        uid,
        (sessions as List).map((s) => Performance.fromJson(s)).toList(),
      ));

      return Right(mapped);
    } on DioException catch (e) {
      return Left(e.response?.data?['message'] ?? 'Failed to fetch performance data.');
    } catch (e) {
      return Left('An unexpected error occurred: $e');
    }
  }
}
