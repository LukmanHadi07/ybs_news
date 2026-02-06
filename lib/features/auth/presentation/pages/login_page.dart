import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth/login_button.dart';
import '../widgets/auth/login_form.dart';
import '../widgets/auth/login_header.dart';
import '../widgets/auth/login_social_section.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginTap() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    FocusManager.instance.primaryFocus?.unfocus();
    context.read<AuthCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpRequired) {
          context.goNamed(RouteNames.otpVerification);
        } else if (state is AuthLoginSuccess) {
          context.goNamed(RouteNames.home);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 1.sh - 48.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LoginHeader(),
                    LoginForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                    ),
                    SizedBox(height: 8.h),
                    LoginButton(
                      onPressed: _onLoginTap,
                      isLoading: isLoading,
                    ),
                    const LoginSocialSection(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
