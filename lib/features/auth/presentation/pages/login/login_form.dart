import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/core/extensions/extensions.dart';

import '../../../../../router/router.dart';
import '../../../../onboarding/onboarding.dart';
import '../../../application/application.dart';
import '../../widgets/widgets.dart';

class LoginForm extends HookConsumerWidget {
  final bool isPasswordOnly;

  const LoginForm({super.key, required this.isPasswordOnly});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FocusScopeNode focusScope = useFocusScopeNode();
    final FocusNode emailFocusNode = useFocusNode();
    final FocusNode passwordFocusNode = useFocusNode();

    final LoginFormState state = ref.watch(loginFormProvider);

    return Form(
      child: Builder(
        builder: (formContext) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isPasswordOnly) ...[
              UserAccountDetails(
                user: ref.watch(userProvider),
                action: context.showSwitchAccountSheet,
              ),
              MSize.verticalSpaceXXLarge,
            ] else ...[
              _Email(focusNode: emailFocusNode),
              24.verticalSpace,
            ],
            _Password(focusNode: passwordFocusNode),
            MSize.verticalSpaceMicro,
            const Align(
              alignment: Alignment.centerRight,
              child: _ForgotPasswordButton(),
            ),
            MSize.verticalSpaceXXLarge,
            MPrimaryButton(
              label: "Log In",
              loading: state.loading,
              onPressed: () {
                focusScope.unfocus();
                if (Form.of(formContext).validate()) {
                  ref.read(loginFormProvider.notifier).loginPressed();
                }
              },
            ),
            24.verticalSpace,
            const GoogleDivider(title: "Login with Google"),
            24.verticalSpace,
            MGoogleButton(onPressed: () {}),
            149.verticalSpace,
            const _CreateAccountButton(),
          ],
        ),
      ),
    );
  }
}

class _CreateAccountButton extends HookConsumerWidget {
  const _CreateAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool hasOnboarded = useMemoized(
      ref.watch(onboardingProvider).isOnboarded,
      [ref],
    );

    return AuthRedirectionText(
      title: "Don’t have an account?",
      buttonText: "Create an account",
      onPressed: () {
        if (hasOnboarded) {
          context.navigateTo(const RegisterRoute());
        } else {
          context.replaceRoute(const RegisterRoute());
        }
      },
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
        enabled: !ref.watch(loginFormProvider).loading,
        onChanged: ref.watch(loginFormProvider.notifier).emailChanged,
        validator: ref.watch(loginFormProvider.notifier).validateEmail,
      );
}

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.navigateTo(const ResetPasswordRoute()),
      child: const MText(
        "Forgot Password?",
        style: MTextStyle.captionMedium,
      ),
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
        enabled: !ref.watch(loginFormProvider).loading,
        onChanged: ref.watch(loginFormProvider.notifier).passwordChanged,
        validator: ref.watch(loginFormProvider.notifier).validatePassword,
      );
}
