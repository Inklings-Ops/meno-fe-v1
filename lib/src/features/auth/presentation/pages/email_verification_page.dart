import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';


class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MScaffold(
      appBar: MAppBar.primary(title: 'Verify Your Email'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24).radius,
        child: Form(
          child: Builder(
            builder: (formContext) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MText(
                  'OTP verification',
                  style: $styles.text.heading2Medium,
                ),
                $styles.spaces.verticalSmall,
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Enter the 4-digit code we just sent to ',
                      ),
                      TextSpan(
                        text: 'jimhalpert26@gmail.com ',
                        style: $styles.text.bodyBold,
                      ),
                      const TextSpan(text: 'to continue.'),
                    ],
                  ),
                  style: $styles.text.bodyRegular,
                ),
                $styles.spaces.verticalXXLarge,
                const MOtpField(),
                24.vSpace,
                const AuthRedirectionText(
                  title: 'Didn’t receive code?',
                  buttonText: 'Send again',
                ),
                $styles.spaces.verticalXXLarge,
                MPrimaryButton(label: 'Continue', onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
