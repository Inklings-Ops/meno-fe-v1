import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/app/router/routes.dart';
import 'package:meno/features/auth/application/application.dart';
import 'package:meno/features/auth/domain/auth_exception.dart';
import 'package:meno/features/auth/domain/domain.dart' show Password;
import 'package:meno/features/auth/presentation/presentation.dart';
import 'package:meno/shared/domain/domain.dart' show Email;
import 'package:meno/shared/extensions/m_snack_bar_extension.dart';
import 'package:meno/shared/shared.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LoginFormWidget extends WatchingStatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _auth = di<AuthManager>();

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final lastUser = _auth.lastKnownUser.value;
    if (lastUser.isSome()) {
      final email = lastUser.toNullable()?.email;
      _emailController.text = email?.getOrElse((_) => '') ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    registerHandler(
      select: (AuthManager m) => m.login.errors,
      handler: (context, e, cancel) {
        if (e == null) return;
        final data = e.error;
        final message = data is AuthException ? data.message : 'Unknown error';
        context.showErrorSnackBar(message);
      },
    );

    final lastKnownUserOption = watchValue((AuthManager m) => m.lastKnownUser);

    final textTheme = MTextTheme.of(context);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          lastKnownUserOption.match(
            () => _EmailField(
              key: const Key('loginForm_emailField'),
              controller: _emailController,
            ),
            (user) => UserAccountDetailsWidget(
              user: user,
              action: () => SwitchAccountModal.show(context),
            ),
          ),
          Spaces.verticalXXLarge,
          _PasswordField(
            key: const Key('loginForm_passwordField'),
            controller: _passwordController,
          ),
          Spaces.verticalSmall,
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => context.push(R.resetPassword),
              child: MText('Forgot Password?', style: textTheme.captionMedium),
            ),
          ),
          Spaces.verticalXXLarge,
          _LoginButton(key: const Key('loginForm_button'), onPressed: _submit),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() == false) return;
    final params = LoginParams(
      Email(_emailController.text),
      Password.login(_passwordController.text),
    );
    _auth.login.run(params);
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
      keyboardType: TextInputType.emailAddress,
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
