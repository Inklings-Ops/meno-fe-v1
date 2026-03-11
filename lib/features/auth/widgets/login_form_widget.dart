import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_core/_core.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/_shared/_shared.dart';
import 'package:meno/features/auth/auth.dart';
import 'package:meno/features/auth/widgets/_widgets.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LoginFormWidget extends WatchingWidget {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = createOnce(GlobalKey<FormState>.new);
    final emailCtrl = createOnce(TextEditingController.new);
    final passwordCtrl = createOnce(TextEditingController.new);

    callOnce((_) {
      final user = di<UserManager>().lastKnownUser.value;
      if (!user.isEmpty) emailCtrl.text = user.email.getOrElse((_) => '');
    });

    final lastKnownUser = watchValue((UserManager m) => m.lastKnownUser);

    final textTheme = MTextTheme.of(context);

    return Form(
      key: formKey,
      autovalidateMode: .onUserInteraction,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          if (lastKnownUser.isEmpty) ...[
            _EmailField(
              key: const Key('loginForm_emailField'),
              controller: emailCtrl,
            ),
          ] else ...[
            UserAccountDetailsWidget(
              user: lastKnownUser,
              action: () => SwitchAccountModal.show(context),
            ),
          ],
          Spaces.verticalXXLarge,
          _PasswordField(
            key: const Key('loginForm_passwordField'),
            controller: passwordCtrl,
          ),
          Spaces.verticalSmall,
          Align(
            alignment: .centerRight,
            child: InkWell(
              onTap: () => context.push(R.resetPassword),
              child: MText('Forgot Password?', style: textTheme.captionMedium),
            ),
          ),
          Spaces.verticalXXLarge,
          _LoginButton(
            key: const Key('loginForm_button'),
            onPressed: () async {
              if (formKey.currentState?.validate() == false) return;
              final params = LoginArgs(
                Email(emailCtrl.text),
                Password.login(passwordCtrl.text),
              );
              di<AuthManager>().login.run(params);
            },
          ),
        ],
      ),
    );
  }
}

class _EmailField extends WatchingWidget {
  const _EmailField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((AuthManager m) => m.login.isRunning);

    return MTextFormField(
      label: 'Email Address',
      hint: 'example@gmail.com',
      prefixIcon: MIcons.mail,
      keyboardType: .emailAddress,
      enabled: !isLoading,
      controller: controller,
      validator: (v) => Email(
        controller.text.isEmpty ? '' : controller.text,
      ).failureOrNull?.msg,
    );
  }
}

class _PasswordField extends WatchingWidget {
  const _PasswordField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((AuthManager m) => m.login.isRunning);

    return MTextFormField(
      label: 'Be Secure',
      hint: 'Enter your password',
      prefixIcon: MIcons.key,
      isPassword: true,
      enabled: !isLoading,
      controller: controller,
      validator: (v) => Password.login(
        controller.text.isEmpty ? '' : controller.text,
      ).failureOrNull?.msg,
    );
  }
}

class _LoginButton extends WatchingWidget {
  const _LoginButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isLoading = watchValue((AuthManager m) => m.login.isRunning);

    return MPrimaryButton(
      label: 'Log In',
      loading: isLoading,
      onPressed: onPressed,
    );
  }
}
