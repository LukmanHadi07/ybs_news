import 'package:fpdart/fpdart.dart';
import 'package:yb_news/core/errors/failures.dart';
import 'package:yb_news/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository repo;

  LogoutUsecase(this.repo);

  Future<Either<Failure, void>> call({required String sessionId}) =>
      repo.logout(sessionId: sessionId);
}
