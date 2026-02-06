import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor({required Dio dio, this.maxRetries = 1}) : _dio = dio;

  final Dio _dio;
  final int maxRetries;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final shouldRetry =
        err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout;

    final retries = (err.requestOptions.extra['retries'] as int?) ?? 0;

    if (!shouldRetry || retries >= maxRetries) {
      handler.next(err);
      return;
    }

    try {
      final options = err.requestOptions;
      options.extra['retries'] = retries + 1;
      _applyAndroidLoopbackFallback(options, retries);
      final response = await _dio.fetch(options);
      handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }

  void _applyAndroidLoopbackFallback(RequestOptions options, int retries) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    if (retries != 0) return;

    final uri = options.uri;
    if (uri.host != '10.0.2.2') return;

    final fallbackUri = uri.replace(host: '10.0.3.2');
    options.path = fallbackUri.toString();
    options.baseUrl = '';
  }
}
