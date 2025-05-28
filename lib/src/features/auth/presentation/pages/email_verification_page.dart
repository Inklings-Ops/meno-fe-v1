import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';


class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});
  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return MScaffold(
      appBar: MAppBar.primary(title: 'Verify Your Email'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Form(
          child: Builder(
            builder: (formContext) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MText(
                  'OTP verification',
                  style: textTheme.heading2Medium,
                ),
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
