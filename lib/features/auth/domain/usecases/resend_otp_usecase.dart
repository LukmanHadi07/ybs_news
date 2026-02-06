import 'package:fpdart/fpdart.dart';
import 'package:yb_news/core/errors/failures.dart';
import 'package:yb_news/features/auth/domain/repositories/auth_repository.dart';

class ResendOtp {
  final AuthRepository repo;

  ResendOtp(this.repo);

  Future<Either<Failure, void>> resendOtp({
    required String email,
  }) {
    return repo.resendOtp(email: email);
  }
}
