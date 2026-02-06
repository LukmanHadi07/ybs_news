import 'package:fpdart/fpdart.dart';
import 'package:yb_news/core/errors/failures.dart';
import 'package:yb_news/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUsecase {
  final AuthRepository repo;

  VerifyOtpUsecase(this.repo);

  Future<Either<Failure, String>> call({
    required String email,
    required String otp,
    required String deviceId,
  }) {
    return repo.verifyOtp(
      email: email,
      otp: otp,
      deviceId: deviceId,
    );
  }
}
