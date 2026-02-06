part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthOtpRequired extends AuthState {
  const AuthOtpRequired({required this.result});

  final LoginResult result;

  @override
  List<Object> get props => [result];
}

class AuthLoginSuccess extends AuthState {
  const AuthLoginSuccess({required this.result});

  final LoginResult result;

  @override
  List<Object> get props => [result];
}

class AuthError extends AuthState {
  const AuthError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class AuthRegisterSuccess extends AuthState {
  const AuthRegisterSuccess();
}
