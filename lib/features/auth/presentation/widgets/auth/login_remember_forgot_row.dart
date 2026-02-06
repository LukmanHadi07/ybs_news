import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yb_news/core/theme/app_colors.dart';

class LoginRememberForgotRow extends StatelessWidget {
  const LoginRememberForgotRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const _RememberMeCheckbox(),
            Text(
              'Remember me',
              style: TextStyle(
                color: Color(0xFF4E4B66),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Forgot the Password ?',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _RememberMeCheckbox extends StatefulWidget {
  const _RememberMeCheckbox();

  @override
  State<_RememberMeCheckbox> createState() => _RememberMeCheckboxState();
}

class _RememberMeCheckboxState extends State<_RememberMeCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: _isChecked,
      visualDensity: VisualDensity.compact,
      onChanged: (value) {
        setState(() {
          _isChecked = value ?? false;
        });
      },
    );
  }
}
