import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

Interceptor loggerInterceptor({required bool enabled}) {
  if (!enabled) return InterceptorsWrapper();

  return PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    compact: true,
    maxWidth: 90,
  );
}
