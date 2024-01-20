import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/application/bloc/auth/auth_bloc.dart';
import '../../../features/onboarding/onboarding.dart';
import '../../../router/router.dart';
import '../loading_page.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final onboardingCubit = context.read<OnboardingCubit>();
        final authStatus = context.read<AuthBloc>().state.status;
        if (mounted) {
          if (onboardingCubit.state != OnboardingState.notCompleted) {
            context.go(Routes.onboarding);
          } else {
            switch (authStatus) {
              case AuthStatus.unauthenticated:
                context.go(Routes.login);
                break;
              case AuthStatus.partiallyAuthenticated:
                context.go(Routes.returnLogin);
                break;
              case AuthStatus.authenticated:
                context.go(Routes.home);
                break;
              default:
            }
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OnboardingCubit, OnboardingState>(
          listenWhen: (p, c) => p != c,
          listener: (context, state) {
            if (state != OnboardingState.notCompleted) {
              context.go(Routes.onboarding);
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (p, c) =>
              p.status != c.status && p.token != c.token && p.user != c.user,
          listener: (context, state) {
            switch (state.status) {
              case AuthStatus.unauthenticated:
                context.go(Routes.login);
                break;
              case AuthStatus.partiallyAuthenticated:
                context.go(Routes.returnLogin);
                break;
              case AuthStatus.authenticated:
                context.go(Routes.home);
                break;
              default:
            }
          },
        ),
      ],
      child: const LoadingPage(),
    );
  }
}
