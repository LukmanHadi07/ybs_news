import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yb_news/core/theme/app_colors.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello',
            style: TextStyle(
              fontSize: 48.sp,
              color: AppColors.grayScale,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Again!',
            style: TextStyle(
              fontSize: 48.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Welcome back you\'ve \nbeen missed',
            style: TextStyle(
              fontSize: 20.sp,
              color: Color(0xFF4E4B66),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
