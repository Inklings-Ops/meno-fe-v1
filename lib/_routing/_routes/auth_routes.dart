import 'package:go_router/go_router.dart';
import 'package:meno/_routing/routes.dart';
import 'package:meno/features/auth/auth.dart';

/// All authentication-related routes (login, register, password reset,
/// email verification).
final class AuthRoutes {
  const AuthRoutes._();

  static List<RouteBase> get routes => [
    GoRoute(
      path: R.login,
      builder: (context, state) {
        return LoginPage(implyLeading: _parseBool(state, 'implyLeading'));
      },
    ),
    GoRoute(
      path: R.register,
      builder: (context, state) {
        return RegisterPage(implyLeading: _parseBool(state, 'implyLeading'));
      },
    ),
    GoRoute(
      path: R.emailVerification,
      builder: (_, __) => const EmailVerificationPage(),
    ),
    GoRoute(
      path: R.resetPassword,
      builder: (_, __) => const ResetPasswordPage(),
    ),
    GoRoute(
      path: R.resetPwdOtp,
      builder: (_, __) => const ResetPasswordOtpVerificationPage(),
    ),
    GoRoute(
      path: R.resetPwdSuccess,
      builder: (_, __) => const ResetPasswordSuccessPage(),
    ),
  ];

  static bool _parseBool(GoRouterState state, String key) {
    return bool.parse(state.uri.queryParameters[key] ?? 'false');
  }
}
