import 'dart:async';
import 'dart:io';

import 'package:demo25/models/remote/failure.dart';
import 'package:demo25/utils/constants.dart';
import 'package:demo25/utils/http/retry_interceptor.dart';
import 'package:demo25/utils/misc.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NetworkUtil {
  factory NetworkUtil() => _networkUtil;

  NetworkUtil._internal();

  static final NetworkUtil _networkUtil = NetworkUtil._internal();

  final _logger = Logger();

  // Cache for Dio instances to avoid recreation
  final Map<String, Dio> _dioCache = {};

  Dio _getHttpClient({required String apiVersion}) {
    final cacheKey = apiVersion;

    if (_dioCache.containsKey(cacheKey)) {
      return _dioCache[cacheKey]!;
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: '${FCConfig.instance!.values.baseUrl}/api/$apiVersion',
        contentType: 'application/json',
        headers: <String, dynamic>{
          'Accept': 'application/json',
          'X-App-Version': Misc.getFullAppVersion(),
          'User-Agent': 'FC/${Misc.getFullAppVersion()}',
        },
        // Fixed timeout configuration
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    // Request interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          const token = 'dummy-token';
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Add request timestamp for debugging
          options.headers['X-Request-Time'] = DateTime.now().toIso8601String();

          return handler.next(options);
        },
      ),
    );

    // Retry interceptor for transient failures
    dio.interceptors.add(RetryInterceptor(dio: dio));

    // Pretty logger for debug mode
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(requestHeader: true, requestBody: true),
      );
    }

    // Certificate handling for development.
    if (kDebugMode) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
          HttpClient()..badCertificateCallback = (_, _, _) => true;
    }

    _dioCache[cacheKey] = dio;
    return dio;
  }

  Never _handleError(DioException error, String method, String url) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    // Log error details
    _logger.e('$method $url failed: $statusCode - ${error.message}');

    // Handle specific status codes
    switch (statusCode) {
      case 400:
        throw Failure(
          message: _extractErrorMessage(responseData) ?? 'Bad request',
          statusCode: statusCode,
        );
      case 401:
        // Clear token on authentication failure
        // getIt<HiveService>().clearBox();
        throw Failure(
          message: 'Authentication failed. Please login again.',
          statusCode: statusCode,
        );
      case 403:
        throw Failure(
          message:
              "Access denied. You don't have permission "
              'to perform this action.',
          statusCode: statusCode,
        );
      case 404:
        throw Failure(message: 'Resource not found', statusCode: statusCode);
      case 422:
        throw Failure(
          message: _extractErrorMessage(responseData) ?? 'Validation failed',
          statusCode: statusCode,
        );
      case 429:
        throw Failure(
          message: 'Too many requests. Please try again later.',
          statusCode: statusCode,
        );
      case 500:
        throw Failure(
          message:
              _extractErrorMessage(responseData) ?? 'Server error occurred',
          statusCode: statusCode,
        );
      case 502:
      case 503:
      case 504:
        throw Failure(
          message: 'Service temporarily unavailable. Please try again later.',
          statusCode: statusCode,
        );
      default:
        // Handle connection errors
        switch (error.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            throw Failure(
              message: 'Request timeout. Please check your connection.',
            );
          case DioExceptionType.connectionError:
            throw Failure(message: 'No internet connection');
          case DioExceptionType.badResponse:
            throw Failure(
              message: 'Invalid response from server',
              statusCode: statusCode,
            );
          case DioExceptionType.unknown:
            throw Failure(message: 'An unexpected error occurred');
          case DioExceptionType.badCertificate:
            throw Failure(message: 'Bad SSL certificate');
          case DioExceptionType.cancel:
            throw Failure(message: 'Request was cancelled');
        }
    }
  }

  /// Extract error message from response data
  String? _extractErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      // Try different common error message fields
      final message = responseData['message'] ?? responseData['error'];

      if (message != null) return message.toString();

      // Handle nested errors object
      final errors = responseData['errors'];
      if (errors != null) {
        if (errors is String) return errors;

        if (errors is Map<String, dynamic>) {
          // Extract first error from validation errors
          final firstError = errors.values.firstOrNull;
          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first.toString();
          }
          if (firstError is String) return firstError;
        }

        if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        }
      }

      // Handle data.message or data.error patterns
      final data = responseData['data'];
      if (data is Map<String, dynamic>) {
        final dataMessage = data['message'] ?? data['error'];
        if (dataMessage != null) return dataMessage.toString();
      }

      // Handle error_description (OAuth style)
      final errorDescription = responseData['error_description'];
      if (errorDescription != null) return errorDescription.toString();
    }

    // Handle string responses
    if (responseData is String && responseData.isNotEmpty) {
      return responseData;
    }

    return null;
  }

  /// Validate response structure
  Map<String, dynamic> _validateResponse(Response<dynamic> response) {
    if (response.data == null) {
      throw Failure(message: 'Empty response from server');
    }

    Logger().d('Response data: ${response.data}');

    if (response.data is! Map<String, dynamic>) {
      throw Failure(message: 'Invalid response format');
    }

    return response.data as Map<String, dynamic>;
  }

  /// GET request with enhanced error handling
  Future<Map<String, dynamic>> get(
    String url, {
    String apiVersion = 'v1',
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _getHttpClient(apiVersion: apiVersion)
          .get<dynamic>(
            url,
            queryParameters: queryParameters,
            options: headers != null ? Options(headers: headers) : null,
          );

      return _validateResponse(response);
    } on SocketException catch (_) {
      throw Failure(message: 'No internet connection');
    } on TimeoutException catch (_) {
      throw Failure(message: 'Request timeout');
    } on DioException catch (err) {
      _handleError(err, 'GET', url);
    }
  }

  /// POST request with enhanced error handling
  Future<Map<String, dynamic>> post(
    String url, {
    dynamic body,
    String apiVersion = 'v1',
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _getHttpClient(apiVersion: apiVersion)
          .post<dynamic>(
            url,
            data: body,
            queryParameters: queryParameters,
            options: headers != null ? Options(headers: headers) : null,
          );

      return _validateResponse(response);
    } on SocketException catch (_) {
      throw Failure(message: 'No internet connection');
    } on TimeoutException catch (_) {
      throw Failure(message: 'Request timeout');
    } on DioException catch (err) {
      _handleError(err, 'POST', url);
    }
  }

  /// PUT request with enhanced error handling
  Future<Map<String, dynamic>> put(
    String url, {
    dynamic body,
    String apiVersion = 'v1',
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _getHttpClient(apiVersion: apiVersion)
          .put<dynamic>(
            url,
            data: body,
            queryParameters: queryParameters,
            options: headers != null ? Options(headers: headers) : null,
          );

      return _validateResponse(response);
    } on SocketException catch (_) {
      throw Failure(message: 'No internet connection');
    } on TimeoutException catch (_) {
      throw Failure(message: 'Request timeout');
    } on DioException catch (err) {
      _handleError(err, 'PUT', url);
    }
  }

  /// PATCH request (new method)
  Future<Map<String, dynamic>> patch(
    String url, {
    dynamic body,
    String apiVersion = 'v1',
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _getHttpClient(apiVersion: apiVersion)
          .patch<dynamic>(
            url,
            data: body,
            queryParameters: queryParameters,
            options: headers != null ? Options(headers: headers) : null,
          );

      return _validateResponse(response);
    } on SocketException catch (_) {
      throw Failure(message: 'No internet connection');
    } on TimeoutException catch (_) {
      throw Failure(message: 'Request timeout');
    } on DioException catch (err) {
      _handleError(err, 'PATCH', url);
    }
  }

  /// DELETE request with enhanced error handling
  Future<Map<String, dynamic>?> delete(
    String url, {
    String apiVersion = 'v1',
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _getHttpClient(apiVersion: apiVersion)
          .delete<dynamic>(
            url,
            queryParameters: queryParameters,
            options: headers != null ? Options(headers: headers) : null,
          );

      // DELETE requests might return empty responses
      if (response.data == null ||
          (response.data is String && (response.data as String).isEmpty)) {
        return null;
      }

      return _validateResponse(response);
    } on SocketException catch (_) {
      throw Failure(message: 'No internet connection');
    } on TimeoutException catch (_) {
      throw Failure(message: 'Request timeout');
    } on DioException catch (err) {
      _handleError(err, 'DELETE', url);
    }
  }

  Future<Map<String, dynamic>> postWithUpload(
    String url, {
    required String filePath,
    required String field,
    String apiVersion = 'v1',
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onUploadProgress,
  }) async {
    try {
      final response = await _getHttpClient(apiVersion: apiVersion)
          .post<dynamic>(
            url,
            data: FormData.fromMap(<String, dynamic>{
              field: await MultipartFile.fromFile(
                filePath,
                filename: filePath.split('/').last,
              ),
              ...?body,
            }),
            queryParameters: queryParameters,
            onSendProgress: onUploadProgress,
          );

      return _validateResponse(response);
    } on SocketException catch (_) {
      throw Failure(message: 'No internet connection');
    } on TimeoutException catch (_) {
      throw Failure(message: 'Upload timeout');
    } on DioException catch (err) {
      _handleError(err, 'POST_UPLOAD', url);
    }
  }

  /// Multiple file upload
  Future<Map<String, dynamic>> postWithMultipleUploads(
    String url, {
    required Map<String, String> filePaths,
    String apiVersion = 'v1',
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onUploadProgress,
  }) async {
    try {
      final formData = <String, dynamic>{};

      for (final entry in filePaths.entries) {
        formData[entry.key] = await MultipartFile.fromFile(
          entry.value,
          filename: entry.value.split('/').last,
        );
      }

      if (body != null) {
        formData.addAll(body);
      }

      final response = await _getHttpClient(apiVersion: apiVersion)
          .post<dynamic>(
            url,
            data: FormData.fromMap(formData),
            queryParameters: queryParameters,
            onSendProgress: onUploadProgress,
          );

      return _validateResponse(response);
    } on SocketException catch (_) {
      throw Failure(message: 'No internet connection');
    } on TimeoutException catch (_) {
      throw Failure(message: 'Upload timeout');
    } on DioException catch (err) {
      _handleError(err, 'POST_MULTI_UPLOAD', url);
    }
  }

  /// Download file with progress tracking
  Future<void> downloadFile(
    String url,
    String savePath, {
    String apiVersion = 'v1',
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onDownloadProgress,
  }) async {
    try {
      await _getHttpClient(apiVersion: apiVersion).download(
        url,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onDownloadProgress,
      );
    } on SocketException catch (_) {
      throw Failure(message: 'No internet connection');
    } on TimeoutException catch (_) {
      throw Failure(message: 'Download timeout');
    } on DioException catch (err) {
      _handleError(err, 'DOWNLOAD', url);
    }
  }

  /// Clear cache (useful for testing or memory management)
  void clearCache() {
    _dioCache.clear();
  }

  /// Check network connectivity
  static Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
