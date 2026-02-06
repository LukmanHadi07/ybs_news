import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'login_remember_forgot_row.dart';
import 'login_text_field.dart';
import 'login_validators.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoginTextField(
            label: 'Email',
            controller: emailController,
            validator: LoginValidators.validateEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          LoginTextField(
            label: 'Password',
            controller: passwordController,
            validator: LoginValidators.validatePassword,
            obscureText: true,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: 4.h),
          const LoginRememberForgotRow(),
        ],
      ),
    );
  }
}
