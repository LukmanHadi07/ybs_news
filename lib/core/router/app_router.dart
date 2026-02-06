import 'package:go_router/go_router.dart';
import 'package:yb_news/features/auth/presentation/pages/otp_verification.dart';
import 'package:yb_news/features/auth/presentation/pages/home_page.dart';
import 'package:yb_news/features/auth/presentation/pages/login_page.dart';
import 'package:yb_news/features/auth/presentation/pages/register_page.dart';

import 'route_names.dart';

class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: RoutePaths.login,
    routes: [
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RoutePaths.otpVerification,
        name: RouteNames.otpVerification,
        builder: (context, state) => const OtpVerificationPage(),
      ),
    ],
  );
}
