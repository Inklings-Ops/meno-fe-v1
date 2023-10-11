import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/core/extensions/extensions.dart';

import '../../../../../router/router.dart';
import '../../../../onboarding/onboarding.dart';
import '../../../application/application.dart';
import 'register_form.dart';

@RoutePage()
class RegisterPage extends ConsumerWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<RegisterFormState>(registerFormProvider, (previous, next) {
      next.option.fold(
        () => null,
        (either) => either.fold(
          (failure) => context.showRegistrationError(failure),
          (_) async {
            final router = context.router;
            context.clearSnackBars();
            ref.read(onboardingProvider).onboardingCompleted();
            await ref.read(authProvider.notifier).checkAuthenticated();
            router.replaceAll([const EmailVerificationRoute()]);
          },
        ),
      );
    });

    return MScaffold(
      appBar: MAppBar.primary(title: "New Account", backText: "Go back"),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      isScrollable: true,
      body: const RegisterForm(),
    );
  }
}
