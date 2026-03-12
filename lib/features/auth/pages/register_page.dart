import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/_routing/routes.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno/features/auth/widgets/_widgets.dart';
import 'package:meno/features/onboarding/manager/_manager.dart';
import 'package:meno_design_system/meno_design_system.dart';

class RegisterPage extends WatchingWidget {
  const RegisterPage({super.key, this.implyLeading = true});

  final bool implyLeading;

  @override
  Widget build(BuildContext context) {
    pushScope(
      init: (getIt) {
        getIt.registerSingleton(RegisterFormManager());
      },
    );

    final isOnboarded = watchValue((OnboardingManager m) => m.isOnboarded);

    return MScaffold(
      appBar: MAppBar.primary(
        title: 'New Account',
        backText: 'Go back',
        implyLeading: implyLeading,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _RegisterForm(key: Key('registerForm')),
            Spaces.verticalXXLarge,
            const GoogleDivider(title: 'Or'),
            Spaces.verticalXLarge,
            const MGoogleButton(title: 'Create with Google'),
            const SizedBox(height: 44),
            AuthRedirectionText(
              title: 'Already have an account?',
              buttonText: 'Log in',
              onPressed: () => isOnboarded
                  ? context.replace(R.login)
                  : context.replace(R.loginWithLeading),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterForm extends WatchingWidget {
  const _RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = createOnce(GlobalKey<FormState>.new);
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

class _FullNameField extends WatchingWidget {
  const _FullNameField({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = createOnce(FocusNode.new);
    final fullName = watchValue((RegisterFormManager m) => m.fullName);
    final isLoading = watchValue((AuthManager m) => m.register.isRunning);
    return MTextFormField(
      label: 'Full Name',
      hint: 'Jim Halpert',
      prefixIcon: MIcons.user,
      focusNode: focusNode,
      enabled: !isLoading,
      onChanged: di<RegisterFormManager>().onFullNameChanged,
      validator: (_) => fullName.failureOrNull?.msg,
    );
  }
}

class _EmailField extends WatchingWidget {
  const _EmailField({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = createOnce(FocusNode.new);
    final email = watchValue((RegisterFormManager m) => m.email);
    final isLoading = watchValue((AuthManager m) => m.register.isRunning);
    return MTextFormField(
      label: 'Email Address',
      hint: 'example@gmail.com',
      prefixIcon: MIcons.mail,
      keyboardType: TextInputType.emailAddress,
      focusNode: focusNode,
      enabled: !isLoading,
      onChanged: di<RegisterFormManager>().onEmailChanged,
      validator: (_) => email.failureOrNull?.msg,
    );
  }
}

class _PasswordField extends WatchingWidget {
  const _PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = createOnce(FocusNode.new);
    final isLoading = watchValue((AuthManager m) => m.register.isRunning);
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
          onChanged: di<RegisterFormManager>().onPasswordChanged,
          enabled: !isLoading,
          focusNode: focusNode,
        ),
        const SizedBox(height: Insets.sm),
        const PasswordRulesTracker(),
      ],
    );
  }
}

class _RememberMeCheckboxTile extends WatchingWidget {
  const _RememberMeCheckboxTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox.square(
          dimension: 20,
          child: Checkbox(
            value: watchValue((RegisterFormManager m) => m.rememberMe),
            onChanged: di<RegisterFormManager>().onRememberMeChanged,
          ),
        ),
        const SizedBox(width: 10),
        MText('Remember me', style: MTextTheme.of(context).captionMedium),
      ],
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = di<RegisterFormManager>();
    final isLoading = watchValue((AuthManager m) => m.register.isRunning);
    final isFormValid = watchValue((RegisterFormManager m) => m.isValid);

    return MPrimaryButton(
      label: 'Create Your Account',
      loading: isLoading,
      disabled: isLoading || !isFormValid,
      onPressed: () {
        FocusScope.of(context).unfocus();
        final args = RegisterArgs(
          fullName: manager.fullName.value,
          email: manager.email.value,
          password: manager.password.value,
        );
        di<AuthManager>().register.run(args);
      },
    );
  }
}
