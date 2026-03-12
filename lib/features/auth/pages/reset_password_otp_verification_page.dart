import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/features/auth/widgets/auth_redirection_text.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ResetPasswordOtpVerificationPage extends WatchingWidget {
  const ResetPasswordOtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = createOnce(GlobalKey<FormState>.new);
    final textTheme = MTextTheme.of(context);
    return MScaffold(
      appBar: MAppBar.primary(title: 'Reset Password'),
      body: Form(
        key: formKey,
        child: Builder(
          builder: (formContext) => SingleChildScrollView(
            padding: const .symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spaces.verticalXLarge,
                MText('OTP Verification', style: textTheme.heading2Medium),
                Spaces.verticalSmall,
                MText(
                  '''Enter the 4-digit code we just sent to jimhalpert26@gmail.com to continue''',
                  maxLines: 3,
                  style: textTheme.bodyRegular,
                ),
                Spaces.verticalXXLarge,
                const MOtpField(),
                Spaces.verticalXLarge,
                const AuthRedirectionText(
                  title: "Didn't receive code?",
                  buttonText: 'Send again',
                ),
                Spaces.verticalXXLarge,
                MPrimaryButton(
                  label: 'Continue',
                  onPressed: () => context.push(R.createNewPassword),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
