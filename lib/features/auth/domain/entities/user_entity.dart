import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final bool isFirstLogin;

  const User({
    required this.id,
    required this.email,
    required this.isFirstLogin,
  });

  @override
  List<Object?> get props => [id, email, isFirstLogin];
}
