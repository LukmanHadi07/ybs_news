import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yb_news/core/network/dio_client.dart';
import 'package:yb_news/core/network/interceptors/auth_interceptor.dart';
import 'package:yb_news/core/storage/secure_storage.dart';
import 'package:yb_news/core/storage/token_storage.dart';
import 'package:yb_news/core/utils/device_id.dart';
import 'package:yb_news/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:yb_news/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:yb_news/features/auth/data/services/email_service.dart';
import 'package:yb_news/features/auth/data/services/otp_service.dart';
import 'package:yb_news/features/auth/data/services/session_service.dart';
import 'package:yb_news/features/auth/domain/repositories/auth_repository.dart';
import 'package:yb_news/features/auth/domain/usecases/login_usecase.dart';
import 'package:yb_news/features/auth/domain/usecases/register_usecase.dart';
import 'package:yb_news/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:yb_news/features/auth/domain/usecases/verif_otp_usecase.dart';
import 'package:yb_news/features/auth/presentation/cubit/auth_cubit.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Core
  sl.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  sl.registerLazySingleton<TokenStorage>(() => SecureTokenStorage(sl()));
  sl.registerLazySingleton<SecureStorage>(SecureStorage.new);
  sl.registerLazySingleton<AuthInterceptor>(() => AuthInterceptor(sl()));
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<DioClient>(
    () => DioClient(dio: sl(), authInterceptor: sl()),
  );
  sl.registerLazySingleton<DeviceIdProvider>(() => DeviceIdProvider(sl()));

  // Data layer
  sl.registerLazySingleton<EmailService>(() => DummyEmailService());
  sl.registerLazySingleton<OtpService>(
    () => OtpService(storage: sl(), emailService: sl()),
  );
  sl.registerLazySingleton<SessionService>(() => SessionService(storage: sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      local: sl(),
      otpService: sl(),
      sessionService: sl(),
    ),
  );

  // Domain layer
  sl.registerLazySingleton<LoginUsecase>(() => LoginUsecase(sl()));
  sl.registerLazySingleton<VerifyOtpUsecase>(() => VerifyOtpUsecase(sl()));
  sl.registerLazySingleton<ResendOtp>(() => ResendOtp(sl()));
  sl.registerLazySingleton<RegisterUsecase>(() => RegisterUsecase(sl()));

  // Presentation layer
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      loginUsecase: sl(),
      verifyOtpUsecase: sl(),
      resendOtpUsecase: sl(),
      registerUsecase: sl(),
      deviceIdProvider: sl(),
      tokenStorage: sl(),
    ),
  );
}
