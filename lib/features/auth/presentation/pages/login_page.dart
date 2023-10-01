import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/features/auth/application/login/login_notifier.dart';
import 'package:meno_fe_v1/features/auth/presentation/widgets/auth_redirection_text.dart';
import 'package:meno_fe_v1/features/auth/presentation/widgets/forgot_password_button.dart';
import 'package:meno_fe_v1/features/auth/presentation/widgets/google_divider.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

@RoutePage()
class LoginPage extends HookConsumerWidget {
  final ValueChanged<bool>? onLogin;
  const LoginPage({super.key, this.onLogin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MColorScheme colorScheme = MColorScheme.of(context)!;

    final emailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();

    final email = ref.watch(loginProvider.select((v) => v.email));
    final password = ref.watch(loginProvider.select((v) => v.password));

    ref.listen<LoginState>(loginProvider, (previous, next) {
      next.option.fold(
        () => null,
        (either) => either.fold(
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: MText(failure.maybeMap(
                  orElse: () => '',
                  message: (m) => m.message,
                  serverError: (_) => 'Server error. Try again',
                )),
              ),
            );
          },
          (_) {
            ScaffoldMessenger.of(context).clearSnackBars();
            onLogin?.call(true);
          },
        ),
      );
    });

    return Scaffold(
      appBar: MAppBar.primary(title: "Log in"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 56),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MTextFormField(
                label: "Email Address",
                hint: "example@gmail.com",
                prefixIcon: MIcons.mail,
                focusNode: emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                onChanged: ref.watch(loginProvider.notifier).emailChanged,
                validator: (_) => email.value.fold(
                  (error) => error.mapOrNull(
                    invalidEmail: (_) => 'Please type a valid email address',
                    empty: (_) => 'This field cannot be empty',
                  ),
                  (_) => null,
                ),
              ),
              24.verticalSpace,
              MTextFormField(
                label: "Be Secure",
                hint: "Enter your password",
                prefixIcon: MIcons.key,
                isPassword: true,
                focusNode: passwordFocusNode,
                enabled: !ref.watch(loginProvider).loading,
                onChanged: ref.watch(loginProvider.notifier).passwordChanged,
                validator: (_) => password.value.fold(
                  (error) => error.mapOrNull(
                    empty: (_) => 'This field cannot be empty',
                  ),
                  (_) => null,
                ),
              ),
              MSize.verticalSpaceMicro,
              const Align(
                alignment: Alignment.centerRight,
                child: ForgotPasswordButton(),
              ),
              MSize.verticalSpaceXXLarge,
              MPrimaryButton(
                label: "Log In",
                loading: ref.watch(loginProvider).loading,
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    ref.read(loginProvider.notifier).loginPressed();
                  }
                },
              ),
              24.verticalSpace,
              const GoogleDivider(title: "Login with Google"),
              24.verticalSpace,
              MSecondaryButton.icon(
                label: "Google",
                icon: Assets.images.google.svg(),
                onPressed: () {},
                borderColor: MColor.grey50,
                foregroundColor: colorScheme.onBackground,
              ),
              149.verticalSpace,
              AuthRedirectionText(
                title: "Don’t have an account?",
                buttonText: "Create an account",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
