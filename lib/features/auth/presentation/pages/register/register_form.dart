import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../../router/router.dart';
import '../../../../onboarding/onboarding.dart';
import '../../../application/application.dart';
import '../../widgets/widgets.dart';

class RegisterForm extends HookConsumerWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FocusScopeNode focusScope = useFocusScopeNode();
    final FocusNode fullNameFocusNode = useFocusNode();
    final FocusNode emailFocusNode = useFocusNode();
    final FocusNode passwordFocusNode = useFocusNode();

    final RegisterFormState state = ref.watch(registerFormProvider);

    return Form(
      child: Builder(
        builder: (formContext) => Column(
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
              loading: state.loading,
              onPressed: () {
                focusScope.unfocus();
                if (Form.of(formContext).validate()) {
                  ref.read(registerFormProvider.notifier).registerPressed();
                }
              },
            ),
            MSize.verticalSpaceXXLarge,
            const GoogleDivider(title: "Create account with Google"),
            24.verticalSpace,
            const MGoogleButton(),
            44.verticalSpace,
            const _LoginButton(),
          ],
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
        enabled: !ref.watch(registerFormProvider).loading,
        onChanged: ref.watch(registerFormProvider.notifier).emailChanged,
        validator: ref.watch(registerFormProvider.notifier).validateEmail,
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
        enabled: !ref.watch(registerFormProvider).loading,
        onChanged: ref.watch(registerFormProvider.notifier).fullNameChanged,
        validator: ref.watch(registerFormProvider.notifier).validateFullName,
      );
}

class _LoginButton extends HookConsumerWidget {
  const _LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool hasOnboarded = useMemoized(
      ref.watch(onboardingProvider).isOnboarded,
      [ref],
    );

    return AuthRedirectionText(
      title: "Already have an account?",
      buttonText: "Log in",
      onPressed: () {
        if (hasOnboarded) {
          context.navigateTo(LoginRoute());
        } else {
          context.replaceRoute(
            LoginRoute(implyLeading: context.router.canNavigateBack),
          );
        }
      },
    );
  }
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
        enabled: !ref.watch(registerFormProvider).loading,
        onChanged: ref.watch(registerFormProvider.notifier).passwordChanged,
        validator: ref.watch(registerFormProvider.notifier).validatePassword,
      );
}
