import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:yb_news/core/storage/token_storage.dart';
import 'package:yb_news/core/utils/device_id.dart';
import 'package:yb_news/features/auth/data/models/login_result.dart';
import 'package:yb_news/features/auth/domain/usecases/login_usecase.dart';
import 'package:yb_news/features/auth/domain/usecases/register_usecase.dart';
import 'package:yb_news/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:yb_news/features/auth/domain/usecases/verif_otp_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required LoginUsecase loginUsecase,
    required VerifyOtpUsecase verifyOtpUsecase,
    required ResendOtp resendOtpUsecase,
    required RegisterUsecase registerUsecase,
    required DeviceIdProvider deviceIdProvider,
    required TokenStorage tokenStorage,
  }) : _loginUsecase = loginUsecase,
       _verifyOtpUsecase = verifyOtpUsecase,
       _resendOtpUsecase = resendOtpUsecase,
       _registerUsecase = registerUsecase,
       _deviceIdProvider = deviceIdProvider,
       _tokenStorage = tokenStorage,
       super(AuthInitial());

  final LoginUsecase _loginUsecase;
  final VerifyOtpUsecase _verifyOtpUsecase;
  final ResendOtp _resendOtpUsecase;
  final RegisterUsecase _registerUsecase;
  final DeviceIdProvider _deviceIdProvider;
  final TokenStorage _tokenStorage;

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());

    final deviceId = await _deviceIdProvider.getOrCreate();
    final result = await _loginUsecase(
      email: email,
      password: password,
      deviceId: deviceId,
    );

    await result.fold(
      (failure) async => emit(AuthError(message: failure.message)),
      (loginResult) async {
        if (loginResult.requiresOtp) {
          emit(AuthOtpRequired(result: loginResult));
          return;
        }

        if (loginResult.sessionId.isEmpty) {
          emit(const AuthError(message: 'Session ID is missing.'));
          return;
        }

        await _tokenStorage.saveAccessToken(loginResult.sessionId);
        emit(AuthLoginSuccess(result: loginResult));
      },
    );
  }

  Future<void> verifyOtp({required String otp}) async {
    final currentState = state;
    if (currentState is! AuthOtpRequired) {
      emit(const AuthError(message: 'OTP session not found.'));
      return;
    }

    final normalizedOtp = otp.trim().toUpperCase();
    final otpRegex = RegExp(r'^[A-Z0-9]{4}$');
    if (!otpRegex.hasMatch(normalizedOtp)) {
      emit(const AuthError(message: 'Invalid OTP'));
      return;
    }

    emit(AuthLoading());

    final deviceId = await _deviceIdProvider.getOrCreate();
    final result = await _verifyOtpUsecase(
      email: currentState.result.user.email,
      otp: normalizedOtp,
      deviceId: deviceId,
    );

    await result.fold(
      (failure) async => emit(AuthError(message: failure.message)),
      (sessionId) async {
        await _tokenStorage.saveAccessToken(sessionId);
        final updated = currentState.result.copyWith(sessionId: sessionId);
        emit(AuthLoginSuccess(result: updated));
      },
    );
  }

  Future<void> resendOtp() async {
    final currentState = state;
    if (currentState is! AuthOtpRequired) {
      emit(const AuthError(message: 'OTP session not found.'));
      return;
    }

    emit(AuthLoading());

    final result = await _resendOtpUsecase.resendOtp(
      email: currentState.result.user.email,
    );

    await result.fold(
      (failure) async => emit(AuthError(message: failure.message)),
      (_) async => emit(AuthOtpRequired(result: currentState.result)),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await _registerUsecase(
      name: name,
      email: email,
      password: password,
    );
    await result.fold(
      (failure) async => emit(AuthError(message: failure.message)),
      (_) async => emit(const AuthRegisterSuccess()),
    );
  }
}
