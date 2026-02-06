import 'package:flutter/foundation.dart';

abstract class EmailService {
  Future<void> sendOtp({required String email, required String otp});
}

class DummyEmailService implements EmailService {
  @override
  Future<void> sendOtp({required String email, required String otp}) async {
    debugPrint('DummyEmailService: OTP for $email => $otp');
  }
}
