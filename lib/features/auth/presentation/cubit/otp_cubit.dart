import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit({this.length = 4}) : super(OtpState.initial(length));

  final int length;

  void updateCode(String code) {
    final trimmed = code.replaceAll(RegExp(r'\s+'), '');
    emit(state.copyWith(code: trimmed, isComplete: trimmed.length == length));
  }

  void clearError() {
    if (state.errorMessage == null) return;
    emit(state.copyWith(errorMessage: null));
  }
}
