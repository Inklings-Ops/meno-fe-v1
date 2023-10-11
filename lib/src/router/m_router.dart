import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../features/auth/presentation/pages/login/login_page.dart';
import '../features/auth/presentation/pages/register/email_verification_page.dart';
import '../features/auth/presentation/pages/register/register_page.dart';
import '../features/auth/presentation/pages/reset_password/create_new_password_page.dart';
import '../features/auth/presentation/pages/reset_password/reset_password_otp_verification_page.dart';
import '../features/auth/presentation/pages/reset_password/reset_password_page.dart';
import '../features/auth/presentation/pages/reset_password/reset_password_success_page.dart';
import '../features/broadcast/presentation/pages/create_broadcast/create_broadcast_page.dart';
import '../features/broadcast/presentation/pages/home_page.dart';
import '../layout/presentation/pages/m_layout.dart';
import '../layout/presentation/pages/pages.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import 'm_routes.dart';

part 'm_router.gr.dart';

@AutoRouterConfig()
class MRouter extends _$MRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: MRoutes.onboarding, page: OnboardingRoute.page),
        AutoRoute(path: MRoutes.login, page: LoginRoute.page),
        AutoRoute(path: MRoutes.register, page: RegisterRoute.page),
        AutoRoute(path: MRoutes.resetPassword, page: ResetPasswordRoute.page),
        AutoRoute(
          path: MRoutes.resetPasswordOtp,
          page: ResetPasswordOtpVerificationRoute.page,
        ),
        AutoRoute(
          path: MRoutes.resetPasswordSuccess,
          page: ResetPasswordSuccessRoute.page,
        ),
        AutoRoute(
          path: MRoutes.createNewPassword,
          page: CreateNewPasswordRoute.page,
        ),
        AutoRoute(
          path: MRoutes.emailVerification,
          page: EmailVerificationRoute.page,
        ),
        AutoRoute(
          path: MRoutes.layout,
          page: MLayoutRoute.page,
          initial: true,
          children: [
            AutoRoute(path: MRoutes.home, page: HomeRoute.page),
            AutoRoute(path: MRoutes.discover, page: DiscoverRoute.page),
            AutoRoute(path: MRoutes.notes, page: NotesRoute.page),
            AutoRoute(path: MRoutes.profile, page: ProfileRoute.page),
          ],
        ),
        CustomRoute(
          path: MRoutes.createBroadcast,
          page: CreateBroadcastRoute.page,
          transitionsBuilder: TransitionsBuilders.slideBottom,
          durationInMilliseconds: 200,
        ),
      ];
}
