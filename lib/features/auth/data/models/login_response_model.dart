import 'package:yb_news/features/auth/data/models/user_models.dart';

class LoginResponseModel {
  final UserModel user;
  final bool requiresOtp;
  final String? otpToken;
  final String sessionId;

  LoginResponseModel({
    required this.user,
    required this.requiresOtp,
    required this.sessionId,
    this.otpToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final userRaw = json['user'];
    String? _stringOrNull(dynamic value) {
      if (value == null) return null;
      final text = value.toString();
      if (text.isEmpty || text == 'null') return null;
      return text;
    }

    final rootUserId = _stringOrNull(json['userId'] ?? json['user_id'] ?? json['id']);
    final rootEmail = _stringOrNull(json['email']);
    final user = userRaw is Map<String, dynamic>
        ? UserModel.fromJson(userRaw)
        : UserModel(
            id: rootUserId ?? '',
            email: rootEmail ?? '',
            isFirstLogin: false,
          );

    final otpToken = _stringOrNull(
      json['otpToken'] ??
          json['otp_token'] ??
          json['otpTokenId'] ??
          json['otp_token_id'],
    );

    final statusRaw = json['status']?.toString();
    final statusUpper = statusRaw?.toUpperCase();
    final requiresOtpRaw =
        json['requiresOtp'] ??
        json['requires_otp'] ??
        json['otpRequired'] ??
        json['otp_required'] ??
        json['isOtpRequired'] ??
        (statusUpper == 'OTP_REQUIRED' ||
            statusUpper == 'OTP_SENT' ||
            statusUpper == 'OTP' ||
            (statusUpper != null && statusUpper.contains('OTP')));

    final sessionRaw =
        json['sessionId'] ??
        json['session_id'] ??
        json['accessToken'] ??
        json['access_token'] ??
        json['token'] ??
        json['jwt'];

    final sessionMap = json['session'] is Map<String, dynamic>
        ? json['session'] as Map<String, dynamic>
        : null;

    final sessionId = _stringOrNull(
      sessionRaw ??
          sessionMap?['id'] ??
          sessionMap?['sessionId'] ??
          sessionMap?['session_id'] ??
          sessionMap?['token'] ??
          sessionMap?['accessToken'] ??
          sessionMap?['access_token'],
    );

    return LoginResponseModel(
      user: user,
      requiresOtp: requiresOtpRaw == true,
      otpToken: otpToken,
      sessionId: sessionId ?? '',
    );
  }
}
