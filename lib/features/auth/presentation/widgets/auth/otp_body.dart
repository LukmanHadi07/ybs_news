import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/auth_cubit.dart';
import 'otp_header.dart';
import '../../cubit/otp_timer_cubit.dart';

class OtpBody extends StatelessWidget {
  const OtpBody({
    super.key,
    required this.otpLength,
    required this.otpBoxBuilder,
  });

  final int otpLength;
  final Widget Function(BuildContext context, int index) otpBoxBuilder;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final email = state is AuthOtpRequired
                    ? state.result.user.email
                    : null;
                return OtpHeader(email: email);
              },
            ),
            SizedBox(height: 24.h),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.w,
              runSpacing: 8.h,
              children: List.generate(
                otpLength,
                (index) => otpBoxBuilder(context, index),
              ),
            ),
            SizedBox(height: 12.h),
            BlocBuilder<OtpTimerCubit, OtpTimerState>(
              builder: (context, timerState) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Resend OTP in '),
                        Text(
                          _formatSeconds(timerState.secondsLeft),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    TextButton(
                      onPressed: timerState.canResend
                          ? () {
                              context.read<AuthCubit>().resendOtp();
                              context.read<OtpTimerCubit>().start();
                            }
                          : null,
                      child: const Text('Resend Code'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String _formatSeconds(int seconds) {
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final remaining = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$remaining';
}
