import 'package:fpdart/fpdart.dart';
import 'package:yb_news/core/errors/failures.dart';
import 'package:yb_news/features/auth/domain/repositories/auth_repository.dart';

class RequestOtpUsecase {
  final AuthRepository repo;

  RequestOtpUsecase(this.repo);

  Future<Either<Failure, void>> call({
    required String email,
  }) {
    return repo.requestOtp(email: email);
  }
}
