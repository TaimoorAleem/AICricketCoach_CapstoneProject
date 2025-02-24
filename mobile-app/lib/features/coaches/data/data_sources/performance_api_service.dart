import 'package:dio/dio.dart';

class PerformanceApiService {
  Future<Map<String, dynamic>> getPerformanceHistory(List<String> playerUids) async {
    final response = await Dio().get(
        'https://my-app-image-174827312206.us-central1.run.app/get-performance-history?uid_list=$playerUids');
    return response.data;
  }
}