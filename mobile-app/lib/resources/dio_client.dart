import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'api_urls.dart';
import 'interceptors.dart';

class DioClient {
  late final Dio _dio;
  String? apiKey;

  DioClient._internal(); // Private named constructor

  static Future<DioClient> init() async {
    final client = DioClient._internal();
    await client._loadApiKey();

    client._dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.baseURL,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-api-key': client.apiKey ?? '',
        },
        responseType: ResponseType.json,
        sendTimeout: const Duration(minutes: 2),
        receiveTimeout: const Duration(minutes: 2),
      ),
    )..interceptors.addAll([
      AuthorizationInterceptor(),
      LoggerInterceptor(),
    ]);

    return client;
  }

  Future<void> _loadApiKey() async {
    try {
      final String response = await rootBundle.loadString('assets/APIKey.json');
      final Map<String, dynamic> data = json.decode(response);
      apiKey = data['x-api-key'];
    } catch (e) {
      print('Error loading API key: $e');
    }
  }

  Future<Response> get(
      String url, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response> post(
      String url, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
      String url, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> delete(
      String url, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // ✅ Add this to expose Dio instance for service registration
  Dio get dio => _dio;
}
