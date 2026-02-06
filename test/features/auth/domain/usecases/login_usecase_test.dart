import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yb_news/core/errors/failures.dart';
import 'package:yb_news/features/auth/domain/entities/user.dart';
import 'package:yb_news/features/auth/domain/repositories/auth_repository.dart';
import 'package:yb_news/features/auth/domain/usecases/login_usecase.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late _MockAuthRepository repository;

  setUp(() {
    repository = _MockAuthRepository();
    useCase = LoginUseCase(repository);
  });

  test('returns User when repository login succeeds', () async {
    const user = User(id: '1', name: 'John', email: 'john@example.com');

    when(() => repository.login(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => const Right(user));

    final result = await useCase(email: 'john@example.com', password: 'password123');

    expect(result, const Right<Failure, User>(user));
    verify(() => repository.login(email: 'john@example.com', password: 'password123')).called(1);
  });
}
