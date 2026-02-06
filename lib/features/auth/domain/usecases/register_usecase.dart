import 'package:fpdart/fpdart.dart';
import 'package:yb_news/core/errors/failures.dart';
import 'package:yb_news/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repo;

  RegisterUsecase(this.repo);

  Future<Either<Failure, void>> call({
    required String email,
    required String password,
  }) {
    return repo.register(email: email, password: password);
  }
}
