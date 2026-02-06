import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_news/core/router/route_names.dart';
import 'package:yb_news/core/theme/app_colors.dart';
import 'package:yb_news/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:yb_news/features/auth/presentation/widgets/auth/login_text_field.dart';
import 'package:yb_news/features/auth/presentation/widgets/auth/register_button.dart';
import 'package:yb_news/features/auth/presentation/widgets/auth/register_social_section.dart';
import 'package:yb_news/features/auth/presentation/widgets/auth/register_validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _rememberMe = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _rememberMe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthRegisterSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Register berhasil, silakan login'),
                  ),
                );
                context.goNamed(RouteNames.login);
              } else if (state is AuthError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _heeaderRegister(),
                    SizedBox(height: 24.h),
                    LoginTextField(
                      label: 'Nama Lengkap',
                      controller: _nameController,
                      validator: RegisterValidators.validateName,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 16.h),
                    LoginTextField(
                      label: 'Email',
                      controller: _emailController,
                      validator: RegisterValidators.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 16.h),
                    LoginTextField(
                      label: 'Konfirmasi Email',
                      controller: _confirmEmailController,
                      validator: (value) =>
                          RegisterValidators.validateConfirmEmail(
                            value,
                            _emailController.text,
                          ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 16.h),
                    LoginTextField(
                      label: 'Password',
                      controller: _passwordController,
                      validator: RegisterValidators.validatePassword,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 16.h),
                    LoginTextField(
                      label: 'Konfirmasi Password',
                      controller: _confirmPasswordController,
                      validator: (value) =>
                          RegisterValidators.validateConfirmPassword(
                            value,
                            _passwordController.text,
                          ),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: _rememberMe,
                          builder: (context, value, _) {
                            return Checkbox(
                              value: value,
                              visualDensity: VisualDensity.compact,
                              onChanged: (checked) =>
                                  _rememberMe.value = checked ?? false,
                            );
                          },
                        ),
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
                    SizedBox(height: 8.h),
                    RegisterButton(
                      onPressed: () {
                        final isValid =
                            _formKey.currentState?.validate() ?? false;
                        if (!isValid) return;
                        FocusManager.instance.primaryFocus?.unfocus();
                        context.read<AuthCubit>().register(
                          name: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        );
                      },
                      isLoading: isLoading,
                    ),
                    SizedBox(height: 12.h),
                    const RegisterSocialSection(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _heeaderRegister() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello',
          style: TextStyle(
            fontSize: 48.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        Text(
          'Signup to get Started',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xFF4E4B66),
          ),
        ),
      ],
    );
  }
}
