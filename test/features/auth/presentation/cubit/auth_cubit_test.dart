import 'package:bloc_test/bloc_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yb_news/core/errors/failures.dart';
import 'package:yb_news/core/storage/token_storage.dart';
import 'package:yb_news/features/auth/domain/entities/user.dart';
import 'package:yb_news/features/auth/domain/usecases/get_me_usecase.dart';
import 'package:yb_news/features/auth/domain/usecases/login_usecase.dart';
import 'package:yb_news/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:yb_news/features/auth/presentation/cubit/auth_state.dart';

class _MockLoginUseCase extends Mock implements LoginUseCase {}

class _MockGetMeUseCase extends Mock implements GetMeUseCase {}

class _MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late AuthCubit cubit;
  late _MockLoginUseCase loginUseCase;
  late _MockGetMeUseCase getMeUseCase;
  late _MockTokenStorage tokenStorage;

  const user = User(id: '1', name: 'John', email: 'john@example.com');

  setUp(() {
    loginUseCase = _MockLoginUseCase();
    getMeUseCase = _MockGetMeUseCase();
    tokenStorage = _MockTokenStorage();

    when(() => tokenStorage.clear()).thenAnswer((_) async {});

    cubit = AuthCubit(loginUseCase, getMeUseCase, tokenStorage);
  });

  tearDown(() async {
    await cubit.close();
  });

  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, Authenticated] when login succeeds',
    build: () {
      when(() => loginUseCase(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => const Right(user));
      return cubit;
    },
    act: (cubit) => cubit.login(email: 'john@example.com', password: 'password123'),
    expect: () => [
      const AuthLoading(),
      const Authenticated(user),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthError] when login fails',
    build: () {
      when(() => loginUseCase(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer(
        (_) async => const Left(
          ServerFailure(
            message: 'Login gagal',
            debugMessage: 'HTTP 500',
          ),
        ),
      );
      return cubit;
    },
    act: (cubit) => cubit.login(email: 'john@example.com', password: 'password123'),
    expect: () => [
      const AuthLoading(),
      const AuthError(message: 'Login gagal', debugMessage: 'HTTP 500'),
    ],
  );
}
