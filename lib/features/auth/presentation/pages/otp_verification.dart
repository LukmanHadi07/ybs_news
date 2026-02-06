import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/otp_cubit.dart';
import '../cubit/otp_timer_cubit.dart';
import '../widgets/auth/otp_body.dart';
import '../widgets/auth/otp_input_box.dart';
import '../widgets/auth/otp_verify_button_bar.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  static const int _otpLength = 4;
  static const int _resendSeconds = 180;
  final _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final _focusNodes = List.generate(_otpLength, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _onOtpChanged(BuildContext context, int index, String value) {
    if (value.length > 1) {
      final trimmed =
          value.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();
      if (trimmed.length == _otpLength) {
        for (var i = 0; i < _otpLength; i++) {
          _controllers[i].text = trimmed[i];
        }
        _focusNodes.last.unfocus();
      }
    } else {
      if (value.isNotEmpty && index < _otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else if (value.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    final code = _controllers.map((c) => c.text).join().toUpperCase();
    context.read<OtpCubit>().updateCode(code);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OtpCubit>(create: (_) => OtpCubit(length: _otpLength)),
        BlocProvider<OtpTimerCubit>(
          create: (_) => OtpTimerCubit(resendSeconds: _resendSeconds)..start(),
        ),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoginSuccess) {
            context.goNamed(RouteNames.home);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: const SizedBox.shrink(),
          ),
          body: OtpBody(
            otpLength: _otpLength,
            otpBoxBuilder: (context, index) => OtpInputBox(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              isLast: index == _otpLength - 1,
              onChanged: (value) => _onOtpChanged(context, index, value),
            ),
          ),
          bottomNavigationBar: const OtpVerifyButtonBar(),
        ),
      ),
    );
  }
}
