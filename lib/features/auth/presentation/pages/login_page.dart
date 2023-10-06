import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/core/extensions/m_extensions.dart';
import 'package:meno_fe_v1/features/auth/application/auth/auth_notifier.dart';
import 'package:meno_fe_v1/features/auth/application/login/login_notifier.dart';
import 'package:meno_fe_v1/features/auth/presentation/widgets/auth_redirection_text.dart';
import 'package:meno_fe_v1/features/auth/presentation/widgets/forgot_password_button.dart';
import 'package:meno_fe_v1/features/auth/presentation/widgets/google_divider.dart';
import 'package:meno_fe_v1/features/onboarding/application/onboarding_provider.dart';
import 'package:meno_fe_v1/router/m_router.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

@RoutePage()
class LoginPage extends HookConsumerWidget {
  final bool implyLeading;
  const LoginPage({super.key, this.implyLeading = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FocusScopeNode focusScope = useFocusScopeNode();
    final FocusNode emailFocusNode = useFocusNode();
    final FocusNode passwordFocusNode = useFocusNode();

    final LoginState state = ref.watch(loginProvider);

    ref.listen<LoginState>(loginProvider, (previous, next) {
      next.option.fold(
        () => null,
        (either) => either.fold(
          (failure) => context.showLoginError(failure),
          (_) async {
            final router = context.router;
            context.clearSnackBars();
            await ref.read(authProvider.notifier).checkAuthenticated();
            if (router.canNavigateBack) {
              ref.read(onboardingProvider).onboardingCompleted();
            }
            router.replaceAll([const MLayoutRoute()]);
          },
        ),
      );
    });

    final onLoginPressed = useCallback(() {
      focusScope.unfocus();
      if (_formKey.currentState?.validate() == true) {
        ref.read(loginProvider.notifier).loginPressed();
      }
    }, []);

    return Scaffold(
      appBar: MAppBar.primary(title: "Log in", implyLeading: implyLeading),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 56),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Email(focusNode: emailFocusNode),
              24.verticalSpace,
              _Password(focusNode: passwordFocusNode),
              MSize.verticalSpaceMicro,
              const Align(
                alignment: Alignment.centerRight,
                child: ForgotPasswordButton(),
              ),
              MSize.verticalSpaceXXLarge,
              MPrimaryButton(
                label: "Log In",
                loading: state.loading,
                onPressed: onLoginPressed,
              ),
              24.verticalSpace,
              const GoogleDivider(title: "Login with Google"),
              24.verticalSpace,
              MGoogleButton(onPressed: () {}),
              149.verticalSpace,
              AuthRedirectionText(
                title: "Don’t have an account?",
                buttonText: "Create an account",
                onPressed: () => context.replaceRoute(const RegisterRoute()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Email extends ConsumerWidget {
  final FocusNode focusNode;
  const _Email({Key? key, required this.focusNode}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => MTextFormField(
        label: "Email Address",
        hint: "example@gmail.com",
        prefixIcon: MIcons.mail,
        focusNode: focusNode,
        keyboardType: TextInputType.emailAddress,
        enabled: !ref.watch(loginProvider).loading,
        onChanged: ref.watch(loginProvider.notifier).emailChanged,
        validator: ref.watch(loginProvider.notifier).validateEmail,
      );
}

class _Password extends ConsumerWidget {
  final FocusNode focusNode;
  const _Password({Key? key, required this.focusNode}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => MTextFormField(
        label: "Be Secure",
        hint: "Enter your password",
        prefixIcon: MIcons.key,
        isPassword: true,
        focusNode: focusNode,
        enabled: !ref.watch(loginProvider).loading,
        onChanged: ref.watch(loginProvider.notifier).passwordChanged,
        validator: ref.watch(loginProvider.notifier).validatePassword,
      );
}
