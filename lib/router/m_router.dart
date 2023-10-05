import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meno_fe_v1/features/auth/presentation/pages/email_verification_page.dart';
import 'package:meno_fe_v1/features/auth/presentation/pages/login_page.dart';
import 'package:meno_fe_v1/features/auth/presentation/pages/register_page.dart';
import 'package:meno_fe_v1/features/auth/presentation/pages/return_login_page.dart';
import 'package:meno_fe_v1/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:meno_fe_v1/layout/m_layout.dart';
import 'package:meno_fe_v1/layout/pages.dart';
import 'package:meno_fe_v1/router/m_routes.dart';

part 'm_router.gr.dart';

@AutoRouterConfig()
class MRouter extends _$MRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: MRoutes.onboarding, page: OnboardingRoute.page),
        AutoRoute(path: MRoutes.login, page: LoginRoute.page),
        AutoRoute(path: MRoutes.returnLogin, page: ReturnLoginRoute.page),
        AutoRoute(path: MRoutes.register, page: RegisterRoute.page),
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
      ];
}
