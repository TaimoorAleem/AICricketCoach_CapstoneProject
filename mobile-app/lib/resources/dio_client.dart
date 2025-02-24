import 'package:dio/dio.dart';
import 'api_urls.dart';
import 'interceptors.dart';

class DioClient {
  late final Dio _dio;

  DioClient()
      : _dio = Dio(
    BaseOptions(
      baseUrl: ApiUrl.baseURL,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      responseType: ResponseType.json,
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.addAll([AuthorizationInterceptor(), LoggerInterceptor()]);

  // GET METHOD with optional base URL override
  Future<Response> get(
      String url, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
        String? overrideBaseUrl,
      }) async {
    try {
      final dioInstance = overrideBaseUrl != null
          ? Dio(BaseOptions(baseUrl: overrideBaseUrl))
          : _dio;

      final Response response = await dioInstance.get(
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

  // POST METHOD with optional base URL override
  Future<Response> post(
      String url, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        String? overrideBaseUrl,
      }) async {
    try {
      final dioInstance = overrideBaseUrl != null
          ? Dio(BaseOptions(baseUrl: overrideBaseUrl))
          : _dio;

      final Response response = await dioInstance.post(
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

  // PUT METHOD with optional base URL override
  Future<Response> put(
      String url, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        String? overrideBaseUrl,
      }) async {
    try {
      final dioInstance = overrideBaseUrl != null
          ? Dio(BaseOptions(baseUrl: overrideBaseUrl))
          : _dio;

      final Response response = await dioInstance.put(
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

  // DELETE METHOD with optional base URL override
  Future<dynamic> delete(
      String url, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        String? overrideBaseUrl,
      }) async {
    try {
      final dioInstance = overrideBaseUrl != null
          ? Dio(BaseOptions(baseUrl: overrideBaseUrl))
          : _dio;

      final Response response = await dioInstance.delete(
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
