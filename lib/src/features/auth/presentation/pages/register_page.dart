import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';
import 'package:meno_fe_v1/src/features/settings/application/application.dart';
import 'package:meno_fe_v1/src/router/router.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key, this.implyLeading = true});
  final bool implyLeading;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        state.option.fold(
          () => null,
          (either) => either.fold(
            (failure) => context.showRegistrationError(failure),
            (success) => null,
          ),
        );
      },
      child: MScaffold(
        appBar: MAppBar.primary(
          title: 'New Account',
          backText: 'Go back',
          implyLeading: implyLeading,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24).radius,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const RegisterForm(),
              $styles.spaces.verticalXXLarge,
              const GoogleDivider(title: 'Or'),
              24.vSpace,
              const MGoogleButton(title: 'Create with Google'),
              44.vSpace,
              BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) => AuthRedirectionText(
                  title: 'Already have an account?',
                  buttonText: 'Log in',
                  onPressed: () {
                    if (state == OnboardingState.completed) {
                      context.replace(Routes.login);
                    } else {
                      context.replace(Routes.loginWithLeading);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
