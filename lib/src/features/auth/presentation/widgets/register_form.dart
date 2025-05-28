import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/auth/auth.dart';

class RegisterForm extends HookWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    return Form(
      key: formKey,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FullNameField(key: Key('registerForm_fullNameField')),
          Spaces.verticalXLarge,
          _EmailField(key: Key('registerForm_emailField')),
          Spaces.verticalXLarge,
          _PasswordField(key: Key('registerForm_passwordField')),
          Spaces.verticalLarge,
          _RememberMeCheckboxTile(key: Key('register_rememberMe_inputField')),
          Spaces.verticalXXLarge,
          _RegisterButton(key: Key('registerForm_button')),
        ],
      ),
    );
  }
}

class _FullNameField extends HookWidget {
  const _FullNameField({super.key});

  @override
  Widget build(BuildContext context) {
    final fullName = context.select((RegisterCubit b) => b.state.fullName);
    final status = context.select((RegisterCubit b) => b.state.status);
    final focusNode = useFocusNode();
    return MTextFormField(
      label: 'Full Name',
      hint: 'Jim Halpert',
      prefixIcon: MIcons.user,
      focusNode: focusNode,
      enabled: !status.isLoading,
      onChanged: context.read<RegisterCubit>().emailChanged,
      validator: (_) => fullName.failureOrNull?.message,
    );
  }
}

class _EmailField extends HookWidget {
  const _EmailField({super.key});

  @override
  Widget build(BuildContext context) {
    final email = context.select((RegisterCubit b) => b.state.email);
    final status = context.select((RegisterCubit b) => b.state.status);
    final focusNode = useFocusNode();
    return MTextFormField(
      label: 'Email Address',
      hint: 'example@gmail.com',
      prefixIcon: MIcons.mail,
      keyboardType: TextInputType.emailAddress,
      focusNode: focusNode,
      enabled: !status.isLoading,
      onChanged: context.read<RegisterCubit>().emailChanged,
      validator: (_) => email.failureOrNull?.message,
    );
  }
}

class _PasswordField extends HookWidget {
  const _PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    final status = context.select((RegisterCubit b) => b.state.status);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        MTextFormField(
          key: const Key('register_form_password_input'),
          hint: 'Must be at least 8 characters',
          label: 'Be secure',
          isPassword: true,
          prefixIcon: MIcons.key,
          onChanged: context.read<RegisterCubit>().passwordChanged,
          enabled: !status.isLoading,
          focusNode: focusNode,
        ),
        const SizedBox(height: Insets.sm),
        const PasswordRulesWidgetTracker(),
      ],
    );
  }
}

class _RememberMeCheckboxTile extends StatelessWidget {
  const _RememberMeCheckboxTile({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return BlocSelector<RegisterCubit, RegisterState, bool?>(
      selector: (state) => state.rememberMe,
      builder: (context, state) => Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Checkbox(
              value: state,
              onChanged: context.read<RegisterCubit>().onRememberMeChanged,
            ),
          ),
          const SizedBox(width: 10),
          MText('Remember me', style: textTheme.captionMedium),
        ],
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((RegisterCubit b) => b.state.status);
    final isFormValid = context.select((RegisterCubit b) => b.state.isValid);
    return MPrimaryButton(
      label: 'Create Your Account',
      loading: status.isLoading,
      disabled: status.isLoading || !isFormValid,
      onPressed: () {
        if (Form.of(context).validate()) {
          FocusScope.of(context).unfocus();
          context.read<RegisterCubit>().register();
        }
      },
    );
  }
}
