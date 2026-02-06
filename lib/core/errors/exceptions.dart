class ServerException implements Exception {
  const ServerException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;
}

class NetworkException implements Exception {
  const NetworkException(this.message);

  final String message;
}

class UnauthorizedException implements Exception {
  const UnauthorizedException(this.message);

  final String message;
}

class CacheException implements Exception {
  const CacheException(this.message);

  final String message;
}
