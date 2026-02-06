import 'package:yb_news/features/auth/domain/entities/user_entity.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.isFirstLogin,
  });

  const UserModel.empty() : super(id: '', email: '', isFirstLogin: false);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      isFirstLogin: json['isFirstLogin'] as bool? ??
          json['is_first_login'] as bool? ??
          false,
    );
  }
}
