import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/core/extensions/m_extensions.dart';
import 'package:meno_fe_v1/features/auth/application/auth/auth_notifier.dart';
import 'package:meno_fe_v1/features/auth/application/register/register_notifier.dart';
import 'package:meno_fe_v1/features/auth/presentation/widgets/auth_redirection_text.dart';
import 'package:meno_fe_v1/features/auth/presentation/widgets/google_divider.dart';
import 'package:meno_fe_v1/features/auth/presentation/widgets/password_rule_widget.dart';
import 'package:meno_fe_v1/features/auth/presentation/widgets/remember_me_checkbox_tile.dart';
import 'package:meno_fe_v1/features/onboarding/application/onboarding_provider.dart';
import 'package:meno_fe_v1/router/m_router.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

@RoutePage()
class RegisterPage extends HookConsumerWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FocusScopeNode focusScope = useFocusScopeNode();
    final FocusNode fullNameFocusNode = useFocusNode();
    final FocusNode emailFocusNode = useFocusNode();
    final FocusNode passwordFocusNode = useFocusNode();

    final RegisterState state = ref.watch(registerProvider);

    ref.listen<RegisterState>(registerProvider, (previous, next) {
      next.option.fold(
        () => null,
        (either) => either.fold(
          (failure) => context.showRegistrationError(failure),
          (_) async {
            final router = context.router;
            context.clearSnackBars();
            ref.read(onboardingProvider).onboardingCompleted();
            await ref.read(authProvider.notifier).checkAuthenticated();
            router.replaceAll([const EmailVerificationRoute()]);
          },
        ),
      );
    });

    final onRegisterPressed = useCallback(() {
      focusScope.unfocus();
      if (_formKey.currentState?.validate() == true) {
        ref.read(registerProvider.notifier).registerPressed();
      }
    }, []);

    return Scaffold(
      appBar: MAppBar.primary(title: "New Account", backText: "Go back"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _FullName(focusNode: fullNameFocusNode),
              24.verticalSpace,
              _Email(focusNode: emailFocusNode),
              24.verticalSpace,
              _Password(focusNode: passwordFocusNode),
              const PasswordRulesWidget(),
              MSize.verticalSpaceLarge,
              const RememberMeCheckboxTile(),
              MSize.verticalSpaceXXLarge,
              MPrimaryButton(
                label: "Create Your Account",
                onPressed: onRegisterPressed,
                loading: state.loading,
              ),
              MSize.verticalSpaceXXLarge,
              const GoogleDivider(title: "Create account with Google"),
              24.verticalSpace,
              const MGoogleButton(),
              44.verticalSpace,
              AuthRedirectionText(
                title: "Already have an account?",
                buttonText: "Log in",
                onPressed: () => context.replaceRoute(LoginRoute()),
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
        enabled: !ref.watch(registerProvider).loading,
        onChanged: ref.watch(registerProvider.notifier).emailChanged,
        validator: ref.watch(registerProvider.notifier).validateEmail,
      );
}

class _FullName extends ConsumerWidget {
  final FocusNode focusNode;
  const _FullName({Key? key, required this.focusNode}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => MTextFormField(
        label: "Full Name",
        hint: "Jim Halpert",
        prefixIcon: MIcons.user,
        focusNode: focusNode,
        enabled: !ref.watch(registerProvider).loading,
        onChanged: ref.watch(registerProvider.notifier).fullNameChanged,
        validator: ref.watch(registerProvider.notifier).validateFullName,
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
        enabled: !ref.watch(registerProvider).loading,
        onChanged: ref.watch(registerProvider.notifier).passwordChanged,
        validator: ref.watch(registerProvider.notifier).validatePassword,
      );
}
