import 'package:fpdart/fpdart.dart';
import 'package:yb_news/core/errors/failures.dart';
import 'package:yb_news/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:yb_news/features/auth/data/models/login_result.dart';
import 'package:yb_news/features/auth/data/services/otp_service.dart';
import 'package:yb_news/features/auth/data/services/session_service.dart';
import 'package:yb_news/features/auth/domain/entities/user_entity.dart';
import 'package:yb_news/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource local;
  final OtpService otpService;
  final SessionService sessionService;

  AuthRepositoryImpl({
    required this.local,
    required this.otpService,
    required this.sessionService,
  });

  @override
  Future<Either<Failure, User>> fetchMe({required String sessionId}) {
    // TODO: implement fetchMe
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, LoginResult>> login({
    required String email,
    required String password,
    required String deviceId,
  }) async {
    try {
      final record = await local.findByEmail(email);
      if (record == null || record.password != password) {
        return const Left(
          ServerFailure(message: 'Invalid email or password'),
        );
      }

      final user = record.toUserModel();

      if (user.isFirstLogin) {
        await otpService.generateAndSend(user.email);
        return Right(
          LoginResult(
            user: user,
            requiresOtp: true,
            otpToken: null,
            sessionId: '',
          ),
        );
      }

      final sessionResult = await sessionService.createOrRefresh(
        email: user.email,
        deviceId: deviceId,
      );

      if (!sessionResult.isAllowed) {
        return Left(
          ServerFailure(message: sessionResult.errorMessage ?? ''),
        );
      }

      return Right(
        LoginResult(
          user: user,
          requiresOtp: false,
          otpToken: null,
          sessionId: sessionResult.sessionId ?? '',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout({required String sessionId}) async {
    try {
      await sessionService.clearBySessionId(sessionId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> requestOtp({
    required String email,
  }) async {
    try {
      await otpService.generateAndSend(email);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resendOtp({
    required String email,
  }) async {
    try {
      final canResend = await otpService.canResend(email);
      if (!canResend) {
        return const Left(
          ServerFailure(message: 'Please wait before resending OTP'),
        );
      }
      await otpService.generateAndSend(email);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp({
    required String email,
    required String otp,
    required String deviceId,
  }) async {
    try {
      final validation = await otpService.validate(email, otp);
      if (validation == OtpValidationResult.expired) {
        return const Left(
          ServerFailure(message: 'OTP expired, please request a new one'),
        );
      }
      if (validation == OtpValidationResult.invalid) {
        return const Left(ServerFailure(message: 'Invalid OTP'));
      }

      await local.updateIsFirstLogin(email, false);

      final sessionResult = await sessionService.createOrRefresh(
        email: email,
        deviceId: deviceId,
      );

      if (!sessionResult.isAllowed) {
        return Left(
          ServerFailure(message: sessionResult.errorMessage ?? ''),
        );
      }

      return Right(sessionResult.sessionId ?? '');
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> register({
    required String email,
    required String password,
  }) async {
    try {
      final exists = await local.emailExists(email);
      if (exists) {
        return const Left(ServerFailure(message: 'Email already exists'));
      }
      await local.createUser(email: email, password: password);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
