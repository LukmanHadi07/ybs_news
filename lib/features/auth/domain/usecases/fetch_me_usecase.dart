import 'package:fpdart/fpdart.dart';
import 'package:yb_news/core/errors/failures.dart';
import 'package:yb_news/features/auth/domain/entities/user_entity.dart';
import 'package:yb_news/features/auth/domain/repositories/auth_repository.dart';

class FetchMeUsecase {
  final AuthRepository repo;

  FetchMeUsecase(this.repo);

  Future<Either<Failure, User>> call({required String sessionId}) =>
      repo.fetchMe(sessionId: sessionId);
}
