import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

class CreateNewPasswordPage extends StatelessWidget {
  const CreateNewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return MScaffold(
      appBar: MAppBar.primary(title: ('Create New Password')),
      body: Form(
        child: Builder(
          builder: (formContext) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spaces.verticalXLarge,
                const UserAccountDetails(),
                Spaces.verticalSmall,
                MText(
                  'Set up new password to continue your experience',
                  maxLines: 2,
                  style: textTheme.captionMedium,
                ),
                Spaces.verticalXXLarge,
                const MTextFormField(
                  label: 'Password',
                  isPassword: true,
                  prefixIcon: MIcons.key,
                  hint: 'Enter your password',
                ),
                Spaces.verticalXLarge,
                const MTextFormField(
                  label: 'Confirm Password',
                  isPassword: true,
                  prefixIcon: MIcons.key,
                  hint: 'Enter your password',
                ),
                Spaces.verticalXXLarge,
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
