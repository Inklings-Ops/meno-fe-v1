import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

class CreateNewPasswordPage extends StatelessWidget {
  const CreateNewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      appBar: MAppBar.primary(title: ('Create New Password')),
      body: Form(
        child: Builder(
          builder: (formContext) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24).radius,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                24.vSpace,
                const UserAccountDetails(),
                $styles.spaces.verticalSmall,
                MText(
                  'Set up new password to continue your experience',
                  maxLines: 2,
                  style: $styles.text.captionMedium,
                ),
                $styles.spaces.verticalXXLarge,
                const MTextFormField(
                  label: 'Password',
                  isPassword: true,
                  prefixIcon: MIcons.key,
                  hint: 'Enter your password',
                ),
                24.vSpace,
                const MTextFormField(
                  label: 'Confirm Password',
                  isPassword: true,
                  prefixIcon: MIcons.key,
                  hint: 'Enter your password',
                ),
                $styles.spaces.verticalXXLarge,
                MPrimaryButton(
                  label: 'Reset Password',
                  onPressed: () => context.push(Routes.resetPwdSuccess),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
