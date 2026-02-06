import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({
    this.code = 'UNKNOWN',
    this.message = 'Something went wrong',
    this.debugMessage = '',
  });

  /// Backend / internal error code
  final String code;

  /// Message yang aman untuk user
  final String message;

  /// Message detail untuk developer / logging
  final String debugMessage;

  @override
  List<Object?> get props => [code, message, debugMessage];
}

// ================== Specific Failures ==================

class NetworkFailure extends Failure {
  const NetworkFailure({
    String code = 'NO_CONNECTION',
    String message = 'No internet connection',
    String debugMessage = '',
  }) : super(code: code, message: message, debugMessage: debugMessage);
}

class ServerFailure extends Failure {
  const ServerFailure({
    String code = 'SERVER_ERROR',
    String message = 'Server error occurred',
    String debugMessage = '',
  }) : super(code: code, message: message, debugMessage: debugMessage);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    String code = 'UNAUTHORIZED',
    String message = 'Unauthorized access',
    String debugMessage = '',
  }) : super(code: code, message: message, debugMessage: debugMessage);
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    String message = 'Unexpected error',
    String debugMessage = '',
  }) : super(code: 'UNKNOWN', message: message, debugMessage: debugMessage);
}
