import 'package:fpdart/fpdart.dart';
import 'package:yb_news/core/errors/failures.dart';
import 'package:yb_news/features/auth/data/models/login_result.dart';
import 'package:yb_news/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResult>> login({
    required String email,
    required String password,
    required String deviceId,
  });

  Future<Either<Failure, void>> requestOtp({
    required String email,
  });

  Future<Either<Failure, String>> verifyOtp({
    required String email,
    required String otp,
    required String deviceId,
  });

  Future<Either<Failure, void>> resendOtp({
    required String email,
  });

  Future<Either<Failure, User>> fetchMe({required String sessionId});

  Future<Either<Failure, void>> logout({required String sessionId});

  Future<Either<Failure, void>> register({
    required String email,
    required String password,
  });
}
