import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient(String baseUrl)
      : dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    contentType: 'application/json',
  ));

  // Example method for GET requests
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      throw Exception('Failed to GET data: $e');
    }
  }

  // Example method for POST requests
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await dio.post(path, data: data);
    } catch (e) {
      throw Exception('Failed to POST data: $e');
    }
  }
}