import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/auth/application/application.dart';
import 'package:meno/features/auth/domain/domain.dart';
import 'package:meno/features/auth/presentation/presentation.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LoginPage extends WatchingWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    registerHandler(
      select: (LoginManager m) => m.login.errors,
      handler: (context, error, cancel) {
        if (error == null) return;
        final data = error.error;
        final message = data is AuthException ? data.message : 'error.error';
        context.showErrorSnackBar(message);
      },
    );

    return MScaffold(
      appBar: MAppBar.primary(title: 'Log in'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginFormWidget(),
            Spaces.verticalXLarge,
            const GoogleDivider(title: 'Or'),
            Spaces.verticalXLarge,
            const MGoogleButton(title: 'Login with Google'),
            const SizedBox(height: 144),
            AuthRedirectionText(
              title: "Don't have an account?",
              buttonText: 'Create an account',
              onPressed: () {
                // if (context.read<LoginCubit>().isOnboarded) {
                //   router.push<void>(Routes.register);
                // } else {
                //   router.replace<void>(Routes.register);
                // }
              },
            ),
          ],
        ),
      ),
    );
  }
}
