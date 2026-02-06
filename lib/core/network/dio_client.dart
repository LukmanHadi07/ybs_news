import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/env.dart';
import '../constants/app_constants.dart';
import '../errors/error_mapper.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logger_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

class DioClient {
  DioClient({required Dio dio, required AuthInterceptor authInterceptor})
    : _dio = dio {
    final baseUrl = _resolveBaseUrl(Env.baseUrl);

    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(
        milliseconds: AppConstants.connectTimeoutMs,
      ),
      receiveTimeout: const Duration(
        milliseconds: AppConstants.receiveTimeoutMs,
      ),
      sendTimeout: const Duration(milliseconds: AppConstants.sendTimeoutMs),
      headers: {'Content-Type': 'application/json'},
    );

    if (Env.isDev) {
      debugPrint('Dio baseUrl => $baseUrl');
    }

    _dio.interceptors.addAll([
      authInterceptor,
      loggerInterceptor(enabled: Env.isDev),
      RetryInterceptor(dio: _dio, maxRetries: 1),
    ]);
  }

  final Dio _dio;

  String _resolveBaseUrl(String rawBaseUrl) {
    final uri = Uri.tryParse(rawBaseUrl);
    if (uri == null || kIsWeb) return rawBaseUrl;

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isLocalHost = uri.host == 'localhost' || uri.host == '127.0.0.1';
    if (!isAndroid || !isLocalHost) return rawBaseUrl;

    return uri.replace(host: '192.168.1.28').toString();
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      return ApiResponse.fromResponse(response, parser);
    } on DioException catch (e) {
      throw _mapToException(e);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final response = await _dio.post<dynamic>(path, data: data);
      return ApiResponse.fromResponse(response, parser);
    } on DioException catch (e) {
      throw _mapToException(e);
    }
  }

  Exception _mapToException(DioException e) {
    final failure = ErrorMapper.map(e);

    if (failure is UnauthorizedFailure) {
      return UnauthorizedException(failure.debugMessage);
    }
    if (failure is NetworkFailure) {
      return NetworkException(failure.debugMessage);
    }
    if (failure is ServerFailure) {
      return ServerException(
        message: failure.debugMessage,
        statusCode: e.response?.statusCode,
      );
    }

    return ServerException(
      message: failure.debugMessage,
      statusCode: e.response?.statusCode,
    );
  }
}

class ApiResponse<T> {
  ApiResponse({required this.data, this.message, this.statusCode});

  final T data;
  final String? message;
  final int? statusCode;

  factory ApiResponse.fromResponse(
    Response<dynamic> response,
    T Function(dynamic json) parser,
  ) {
    final raw = response.data;

    dynamic payload = raw;
    if (raw is Map<String, dynamic> && raw.containsKey('data')) {
      payload = raw['data'] ?? raw;
    }

    if (payload == null) {
      throw const ServerException(message: 'Response payload is null');
    }

    return ApiResponse<T>(
      data: parser(payload),

      message: (raw is Map<String, dynamic>)
          ? raw['message']?.toString()
          : null,
      statusCode: response.statusCode,
    );
  }
}
