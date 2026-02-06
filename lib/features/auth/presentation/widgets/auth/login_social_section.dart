import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:yb_news/core/router/route_names.dart';
import 'package:yb_news/core/theme/app_colors.dart';
import 'package:yb_news/core/theme/app_images.dart';

class LoginSocialSection extends StatelessWidget {
  const LoginSocialSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.r),
      child: Center(
        child: Column(
          children: [
            Text(
              'or continue with',
              style: TextStyle(
                color: Color(0xFF4E4B66),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: 117.w,
              height: 48.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffEEF1F4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: () {},
                child: Row(
                  children: [
                    SvgPicture.asset(AppImages.logoGoogle, width: 30),
                    Text(
                      'Google',
                      style: TextStyle(
                        color: const Color(0xff667080),
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "don't have an account ?",
                  style: TextStyle(
                    color: Color(0xFF4E4B66),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextButton(
                  onPressed: () => context.goNamed(RouteNames.register),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
