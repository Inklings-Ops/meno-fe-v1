import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/core/extensions/extensions.dart';

import '../../../../../router/router.dart';
import '../../../../onboarding/onboarding.dart';
import '../../../application/application.dart';
import '../../../domain/inputs/i_email.dart';
import 'login_form.dart';

@RoutePage()
class LoginPage extends StatefulHookConsumerWidget {
  final bool implyLeading;
  final bool isPasswordOnly;

  const LoginPage({
    super.key,
    this.implyLeading = false,
    this.isPasswordOnly = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final bool hasOnboarded = useMemoized(
      ref.watch(onboardingProvider).isOnboarded,
      [ref],
    );

    ref.listen<LoginFormState>(loginFormProvider, (previous, next) {
      next.option.fold(
        () => null,
        (either) => either.fold(
          (failure) => context.showLoginError(failure),
          (_) async {
            final router = context.router;
            if (!hasOnboarded) {
              ref.read(onboardingProvider).onboardingCompleted();
            }
            router.replaceAll([const MLayoutRoute()]);
          },
        ),
      );
    });

    return Scaffold(
      appBar: MAppBar.primary(
        title: "Log in",
        implyLeading: widget.implyLeading,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 56),
        child: LoginForm(isPasswordOnly: widget.isPasswordOnly),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isPasswordOnly) {
        final IEmail email = ref.read(authProvider).user.email;
        ref.read(loginFormProvider.notifier).emailChanged(email.get()!);
      }
    });
  }
}
