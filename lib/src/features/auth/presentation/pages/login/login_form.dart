import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../../router/router.dart';
import '../../../../onboarding/onboarding.dart';
import '../../../application/application.dart';
import '../../widgets/widgets.dart';

class LoginForm extends HookConsumerWidget {
  final bool isPasswordOnly;

  const LoginForm({super.key, required this.isPasswordOnly});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool hasOnboarded = useMemoized(
      ref.watch(onboardingProvider).isOnboarded,
      [ref],
    );

    final formState = ref.watch(loginFormNotifierProvider);
    final formNotifier = ref.watch(loginFormNotifierProvider.notifier);

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
              MTextFormField(
                label: "Email Address",
                hint: "example@gmail.com",
                prefixIcon: MIcons.mail,
                keyboardType: TextInputType.emailAddress,
                enabled: !formState.loading,
                onChanged: formNotifier.emailChanged,
                validator: formNotifier.validateEmail,
              ),
              24.verticalSpace,
            ],
            MTextFormField(
              label: "Be Secure",
              hint: "Enter your password",
              prefixIcon: MIcons.key,
              isPassword: true,
              enabled: !formState.loading,
              onChanged: formNotifier.passwordChanged,
              validator: formNotifier.validatePassword,
            ),
            MSize.verticalSpaceMicro,
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => context.push(Routes.resetPassword),
                child: const MText(
                  "Forgot Password?",
                  style: MTextStyle.captionMedium,
                ),
              ),
            ),
            MSize.verticalSpaceXXLarge,
            MPrimaryButton(
              label: "Log In",
              loading: formState.loading,
              onPressed: () {
                if (Form.of(formContext).validate()) {
                  FocusScope.of(context).unfocus();
                  ref.read(loginFormNotifierProvider.notifier).loginPressed();
                }
              },
            ),
            24.verticalSpace,
            const GoogleDivider(title: "Login with Google"),
            24.verticalSpace,
            MGoogleButton(onPressed: () {}),
            149.verticalSpace,
            AuthRedirectionText(
              title: "Don’t have an account?",
              buttonText: "Create an account",
              onPressed: () {
                if (hasOnboarded) {
                  context.push("/register?implyLeading=true");
                } else {
                  context.go(Routes.register);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
