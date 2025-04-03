import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/services.dart'; // To load local files
import 'api_urls.dart';
import 'interceptors.dart';

class DioClient {
  late final Dio _dio;
  String? apiKey;

  DioClient() {
    _loadApiKey().then((value) {
      _dio = Dio(
        BaseOptions(
          baseUrl: ApiUrl.baseURL,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-api-key': apiKey ?? '', // Add the apiKey here
          },
          responseType: ResponseType.json,
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      )..interceptors.addAll([AuthorizationInterceptor(), LoggerInterceptor()]);
    });
  }

  // Load the API key from the local JSON file
  Future<void> _loadApiKey() async {
    try {
      final String response = await rootBundle.loadString('assets/APIKey.json');
      final Map<String, dynamic> data = json.decode(response);

      apiKey = data['x-api-key'];  // Assign the value from JSON to apiKey
    } catch (e) {
      print('Error loading API key: $e');
    }
  }

  // GET METHOD
  Future<Response> get(
      String url, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.get(
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

  // POST METHOD
  Future<Response> post(
      String url, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PUT METHOD
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
      final Response response = await _dio.put(
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

  // DELETE METHOD
  Future<dynamic> delete(
      String url, {
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final Response response = await _dio.delete(
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
}
