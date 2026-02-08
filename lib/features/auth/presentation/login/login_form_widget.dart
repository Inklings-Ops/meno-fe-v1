import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/auth/application/application.dart';
import 'package:meno/features/auth/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _LoginFields(),
          Spaces.verticalSmall,
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => context.push(R.resetPassword),
              child: MText('Forgot Password?', style: textTheme.captionMedium),
            ),
          ),
          Spaces.verticalXXLarge,
          const _LoginButton(key: Key('loginForm_button')),
        ],
      ),
    );
  }
}

class _LoginFields extends WatchingWidget {
  const _LoginFields();

  @override
  Widget build(BuildContext context) {
    final lastKnownUserOption = watchValue((LoginManager m) => m.lastKnownUser);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        lastKnownUserOption.match(
          () => const _EmailField(key: Key('loginForm_emailField')),
          (user) => UserAccountDetailsWidget(
            user: user,
            action: () {
              // When switching accounts, reset login manager
              di<LoginManager>().resetToNewUser();
              // Show switch account modal
              // context.push(R.switchAccountModal);
            },
          ),
        ),
        Spaces.verticalXXLarge,
        const _PasswordField(key: Key('loginForm_passwordField')),
      ],
    );
  }
}

class _EmailField extends WatchingWidget {
  const _EmailField({super.key});

  @override
  Widget build(BuildContext context) {
    final email = watchValue((LoginManager m) => m.email);
    final isLoading = watchValue((LoginManager m) => m.login.isRunning);

    return MTextFormField(
      label: 'Email Address',
      hint: 'example@gmail.com',
      prefixIcon: MIcons.mail,
      keyboardType: TextInputType.emailAddress,
      enabled: !isLoading,
      initialValue: email.getOrNull(),
      onChanged: di<LoginManager>().emailChanged,
      validator: (_) => email.failureOrNull?.msg,
    );
  }
}

class _PasswordField extends WatchingWidget {
  const _PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    final password = watchValue((LoginManager m) => m.email);
    final isLoading = watchValue((LoginManager m) => m.login.isRunning);

    return MTextFormField(
      label: 'Be Secure',
      hint: 'Enter your password',
      prefixIcon: MIcons.key,
      isPassword: true,
      enabled: !isLoading,
      onChanged: di<LoginManager>().passwordChanged,
      validator: (_) => password.failureOrNull?.msg,
    );
  }
}

class _LoginButton extends WatchingWidget {
  const _LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((LoginManager m) => m.login.isRunning);
    final isFormValid = watchValue((LoginManager m) => m.isValid);

    return MPrimaryButton(
      label: 'Log In',
      loading: isLoading,
      disabled: isLoading || !isFormValid,
      onPressed: () {
        if (Form.of(context).validate()) {
          FocusScope.of(context).unfocus();
          di<LoginManager>().login.run();
        }
      },
    );
  }
}
