import 'package:yb_news/features/auth/domain/entities/user_entity.dart';

class LoginResult {
  final User user;
  final bool requiresOtp;
  final String? otpToken;
  final String sessionId;

  LoginResult({
    required this.user,
    required this.requiresOtp,
    required this.otpToken,
    required this.sessionId,
  });

  LoginResult copyWith({
    User? user,
    bool? requiresOtp,
    String? otpToken,
    String? sessionId,
  }) {
    return LoginResult(
      user: user ?? this.user,
      requiresOtp: requiresOtp ?? this.requiresOtp,
      otpToken: otpToken ?? this.otpToken,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  @override
  String toString() {
    return 'LoginResult(user: $user, requiresOtp: $requiresOtp, otpToken: $otpToken, sessionId: $sessionId)';
  }
}
