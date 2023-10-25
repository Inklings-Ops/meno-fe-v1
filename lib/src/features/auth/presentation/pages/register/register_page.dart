import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/m_snack_bar_extensions.dart';

import '../../../../../router/router.dart';
import '../../../application/application.dart';
import 'register_form.dart';

class RegisterPage extends ConsumerWidget {
  final bool implyLeading;

  const RegisterPage({super.key, this.implyLeading = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(registerFormNotifierProvider, (previous, next) {
      next.option.fold(
        () => null,
        (either) => either.fold(
          (failure) => context.showRegistrationError(failure),
          (_) {
            context.clearSnackBars();
            context.go(Routes.emailVerification);
          },
        ),
      );
    });

    return MScaffold(
      appBar: MAppBar.primary(
        title: "New Account",
        backText: "Go back",
        implyLeading: implyLeading,
      ),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      body: const SingleChildScrollView(
        child: RegisterForm(),
      ),
    );
  }
}
