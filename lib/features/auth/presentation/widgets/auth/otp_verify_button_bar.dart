import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/auth_cubit.dart';
import '../../cubit/otp_cubit.dart';

class OtpVerifyButtonBar extends StatelessWidget {
  const OtpVerifyButtonBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtpCubit, OtpState>(
      builder: (context, otpState) {
        return BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            final isReady = otpState.isComplete;
            final isSubmitting = authState is AuthLoading;
            return SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 12.h),
                child: SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed:
                        isReady && !isSubmitting
                            ? () => context.read<AuthCubit>().verifyOtp(
                              otp: otpState.code,
                            )
                            : null,
                    child: Text(isSubmitting ? 'Verifying...' : 'Verify OTP'),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
