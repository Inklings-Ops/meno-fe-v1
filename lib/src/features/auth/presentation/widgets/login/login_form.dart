import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

class LoginForm extends HookWidget {
  const LoginForm({required this.isPasswordOnly, super.key});
  final bool isPasswordOnly;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    final formKey = useMemoized(GlobalKey<FormState>.new);
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isPasswordOnly) ...[
            UserAccountDetails(
              action: () => context.showSwitchAccountSheet<void>(),
            ),
            Spaces.verticalXXLarge,
          ] else ...[
            const LoginEmailField(),
            Spaces.verticalXLarge,
          ],
          const LoginPasswordField(),
          Spaces.verticalSmall,
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => router.push(Routes.resetPassword),
              child: MText(
                'Forgot Password?',
                style: textTheme.captionMedium,
              ),
            ),
          ),
          Spaces.verticalXXLarge,
          const LoginButton(),
        ],
      ),
    );
  }
}
