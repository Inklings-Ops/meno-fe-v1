import 'package:flutter/material.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      appBar: MAppBar.primary(title: 'Log in'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: .stretch,
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
              onPressed: () => context.push(R.register),
            ),
          ],
        ),
      ),
    );
  }
}
