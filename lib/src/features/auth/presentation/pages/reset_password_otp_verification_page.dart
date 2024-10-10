import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';


class ResetPasswordOtpVerificationPage extends StatelessWidget {
  const ResetPasswordOtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return MScaffold(
      appBar: MAppBar.primary(title: 'Reset Password'),
      body: Form(
        child: Builder(
          builder: (formContext) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spaces.verticalXLarge,
                MText('OTP Verification', style: textTheme.heading2Medium),
                Spaces.verticalSmall,
                MText(
                  'Enter the 4-digit code we just sent to jimhalpert26@gmail.com to continue',
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
                  onPressed: () => router.push(Routes.createNewPassword),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
