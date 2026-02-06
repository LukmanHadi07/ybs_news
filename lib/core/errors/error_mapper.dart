import 'package:dio/dio.dart';

import 'exceptions.dart';
import 'failures.dart';

class ErrorMapper {
  const ErrorMapper._();

  static Failure map(Object error, [StackTrace? stackTrace]) {
    if (error is Failure) return error;

    if (error is UnauthorizedException) {
      return UnauthorizedFailure(
        message: 'Sesi berakhir. Silakan login lagi.',
        debugMessage: error.message,
      );
    }

    if (error is ServerException) {
      return ServerFailure(
        message: 'Terjadi kendala pada server. Coba lagi nanti.',
        debugMessage: '${error.message} (code: ${error.statusCode})',
      );
    }

    if (error is NetworkException) {
      return NetworkFailure(
        message: 'Koneksi internet bermasalah. Periksa jaringan kamu.',
        debugMessage: error.message,
      );
    }

    if (error is DioException) {
      final type = error.type;
      if (type == DioExceptionType.connectionTimeout ||
          type == DioExceptionType.sendTimeout ||
          type == DioExceptionType.receiveTimeout ||
          type == DioExceptionType.connectionError) {
        return NetworkFailure(
          message: 'Koneksi timeout. Coba lagi.',
          debugMessage: error.message ?? error.toString(),
        );
      }

      final statusCode = error.response?.statusCode;
      if (statusCode == 401) {
        return UnauthorizedFailure(
          message: 'Sesi berakhir. Silakan login ulang.',
          debugMessage: 'HTTP 401: ${error.response?.data}',
        );
      }

      return ServerFailure(
        message: 'Permintaan gagal diproses. Coba lagi nanti.',
        debugMessage: 'DioException[$statusCode]: ${error.response?.data}',
      );
    }

    return UnknownFailure(
      message: 'Terjadi kesalahan tidak terduga.',
      debugMessage: '$error\n$stackTrace',
    );
  }
}
