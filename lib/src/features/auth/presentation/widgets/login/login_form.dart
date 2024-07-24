import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

class LoginForm extends HookWidget {
  const LoginForm({super.key, required this.isPasswordOnly});
  final bool isPasswordOnly;

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isPasswordOnly) ...[
            UserAccountDetails(action: context.showSwitchAccountSheet),
            $styles.spaces.verticalXXLarge,
          ] else ...[
            LoginEmailField(isPwdOnly: isPasswordOnly),
            SizedBox(height: 24.toScale),
          ],
          const LoginPasswordField(),
          $styles.spaces.verticalSmall,
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => context.push(Routes.resetPassword),
              child: MText(
                'Forgot Password?',
                style: $styles.text.captionMedium,
              ),
            ),
          ),
          $styles.spaces.verticalXXLarge,
          const LoginButton(),
        ],
      ),
    );
  }
}
