import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

class LoginForm extends HookWidget {
  const LoginForm({required this.isPasswordOnly, super.key});
  final bool isPasswordOnly;

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isPasswordOnly) ...[
            UserAccountDetails(
              action: () => router.push(Routes.switchAccountModal),
            ),
            Spaces.verticalXXLarge,
          ] else ...[
            const _EmailField(key: Key('loginForm_emailField')),
            Spaces.verticalXLarge,
          ],
          const _PasswordField(key: Key('loginForm_passwordField')),
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
          const _LoginButton(key: Key('loginForm_button')),
        ],
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({super.key});

  @override
  Widget build(BuildContext context) {
    final email = context.select((LoginCubit bloc) => bloc.state.email);
    final status = context.select((LoginCubit b) => b.state.status);
    return MTextFormField(
      label: 'Email Address',
      hint: 'example@gmail.com',
      prefixIcon: MIcons.mail,
      keyboardType: TextInputType.emailAddress,
      enabled: !status.isLoading,
      onChanged: context.read<LoginCubit>().emailChanged,
      validator: (_) => email.failureOrNull?.message,
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    final password = context.select((LoginCubit b) => b.state.password);
    final status = context.select((LoginCubit b) => b.state.status);
    return MTextFormField(
      label: 'Be Secure',
      hint: 'Enter your password',
      prefixIcon: MIcons.key,
      isPassword: true,
      enabled: !status.isLoading,
      onChanged: context.read<LoginCubit>().passwordChanged,
      validator: (_) => password.failureOrNull?.message,
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((LoginCubit b) => b.state.status);
    final isFormValid = context.select((LoginCubit b) => b.state.isValid);
    return MPrimaryButton(
      label: 'Log In',
      loading: status.isLoading,
      disabled: status.isLoading || !isFormValid,
      onPressed: () {
        if (Form.of(context).validate()) {
          FocusScope.of(context).unfocus();
          context.read<LoginCubit>().login();
        }
      },
    );
  }
}
