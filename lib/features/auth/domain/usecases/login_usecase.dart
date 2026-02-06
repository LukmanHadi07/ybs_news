import 'package:fpdart/fpdart.dart';
import 'package:yb_news/core/errors/failures.dart';
import 'package:yb_news/features/auth/data/models/login_result.dart';
import 'package:yb_news/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repo;

  LoginUsecase(this.repo);

  Future<Either<Failure, LoginResult>> call({
    required String email,
    required String password,
    required String deviceId,
  }) {
    return repo.login(email: email, password: password, deviceId: deviceId);
  }
}
