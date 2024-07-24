import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

class ResetPasswordOtpVerificationPage extends StatelessWidget {
  const ResetPasswordOtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      appBar: MAppBar.primary(title: 'Reset Password'),
      body: Form(
        child: Builder(
          builder: (formContext) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24).radius,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                24.vSpace,
                MText('OTP Verification', style: $styles.text.heading2Medium),
                $styles.spaces.verticalSmall,
                MText(
                  'Enter the 4-digit code we just sent to jimhalpert26@gmail.com to continue',
                  maxLines: 3,
                  style: $styles.text.bodyRegular,
                ),
                $styles.spaces.verticalXXLarge,
                const MOtpField(),
                24.vSpace,
                const AuthRedirectionText(
                  title: "Didn't receive code?",
                  buttonText: 'Send again',
                ),
                $styles.spaces.verticalXXLarge,
                MPrimaryButton(
                  label: 'Continue',
                  onPressed: () => context.push(Routes.createNewPassword),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
