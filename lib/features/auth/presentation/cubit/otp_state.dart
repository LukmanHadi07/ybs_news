part of 'otp_cubit.dart';

class OtpState extends Equatable {
  const OtpState({
    required this.code,
    required this.isComplete,
    required this.length,
    this.errorMessage,
  });

  final String code;
  final bool isComplete;
  final int length;
  final String? errorMessage;

  factory OtpState.initial(int length) {
    return OtpState(code: '', isComplete: false, length: length);
  }

  OtpState copyWith({
    String? code,
    bool? isComplete,
    String? errorMessage,
  }) {
    return OtpState(
      code: code ?? this.code,
      isComplete: isComplete ?? this.isComplete,
      length: length,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [code, isComplete, length, errorMessage];
}
