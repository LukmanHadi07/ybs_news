import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpTimerCubit extends Cubit<OtpTimerState> {
  OtpTimerCubit({required int resendSeconds})
      : _resendSeconds = resendSeconds,
        super(OtpTimerState(secondsLeft: resendSeconds));

  final int _resendSeconds;
  Timer? _timer;

  void start() {
    _timer?.cancel();
    emit(OtpTimerState(secondsLeft: _resendSeconds));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsLeft <= 1) {
        timer.cancel();
        emit(const OtpTimerState(secondsLeft: 0));
      } else {
        emit(OtpTimerState(secondsLeft: state.secondsLeft - 1));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

class OtpTimerState extends Equatable {
  const OtpTimerState({required this.secondsLeft});

  final int secondsLeft;

  bool get canResend => secondsLeft == 0;

  @override
  List<Object> get props => [secondsLeft];
}
