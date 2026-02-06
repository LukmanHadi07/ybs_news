import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpHeader extends StatelessWidget {
  const OtpHeader({super.key, required this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final target = (email == null || email!.isEmpty) ? 'your email' : email!;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'OTP Verification',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 32.sp,
              color: const Color(0xff4E4B66),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Enter the OTP sent to $target",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: const Color(0xff4E4B66),
            ),
          ),
        ],
      ),
    );
  }
}
