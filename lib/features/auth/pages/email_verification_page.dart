import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/auth/widgets/auth_redirection_text.dart';
import 'package:meno_design_system/meno_design_system.dart';

class EmailVerificationPage extends WatchingWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = createOnce(GlobalKey<FormState>.new);

    final textTheme = MTextTheme.of(context);

    return MScaffold(
      appBar: MAppBar.primary(title: 'Verify Your Email'),
      body: SingleChildScrollView(
        padding: const .symmetric(vertical: 24),
        child: Form(
          key: formKey,
          child: Builder(
            builder: (formContext) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MText('OTP verification', style: textTheme.heading2Medium),
                Spaces.verticalSmall,
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Enter the 4-digit code we just sent to ',
                      ),
                      TextSpan(
                        text: 'jimhalpert26@gmail.com ',
                        style: textTheme.bodyBold,
                      ),
                      const TextSpan(text: 'to continue.'),
                    ],
                  ),
                  style: textTheme.bodyRegular,
                ),
                Spaces.verticalXXLarge,
                const MOtpField(),
                Spaces.verticalXLarge,
                const AuthRedirectionText(
                  title: 'Didn’t receive code?',
                  buttonText: 'Send again',
                ),
                Spaces.verticalXXLarge,
                MPrimaryButton(label: 'Continue', onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
