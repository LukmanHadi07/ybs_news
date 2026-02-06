import 'package:yb_news/features/auth/data/models/user_models.dart';

class LocalUserRecord {
  LocalUserRecord({
    required this.id,
    required this.email,
    required this.password,
    required this.isFirstLogin,
  });

  final String id;
  final String email;
  final String password;
  final bool isFirstLogin;

  factory LocalUserRecord.fromJson(Map<String, dynamic> json) {
    return LocalUserRecord(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      isFirstLogin: json['isFirstLogin'] as bool? ??
          json['is_first_login'] as bool? ??
          false,
    );
  }

  LocalUserRecord copyWith({
    String? id,
    String? email,
    String? password,
    bool? isFirstLogin,
  }) {
    return LocalUserRecord(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
    );
  }

  UserModel toUserModel() {
    return UserModel(
      id: id,
      email: email,
      isFirstLogin: isFirstLogin,
    );
  }
}
