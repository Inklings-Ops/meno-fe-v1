import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
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

    final bool hasOnboarded = useMemoized(
      ref.watch(onboardingProvider).isOnboarded,
      [ref],
    );

    final formState = ref.watch(registerFormNotifierProvider);
    final formNotifier = ref.watch(registerFormNotifierProvider.notifier);

    return Form(
      child: Builder(
        builder: (formContext) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MTextFormField(
              label: "Full Name",
              hint: "Jim Halpert",
              prefixIcon: MIcons.user,
              focusNode: focusScope,
              enabled: !formState.loading,
              onChanged: formNotifier.fullNameChanged,
              validator: formNotifier.validateFullName,
            ),
            24.verticalSpace,
            MTextFormField(
              label: "Email Address",
              hint: "example@gmail.com",
              prefixIcon: MIcons.mail,
              focusNode: focusScope,
              keyboardType: TextInputType.emailAddress,
              enabled: !formState.loading,
              onChanged: formNotifier.emailChanged,
              validator: formNotifier.validateEmail,
            ),
            24.verticalSpace,
            MTextFormField(
              label: "Be Secure",
              hint: "Enter your password",
              prefixIcon: MIcons.key,
              isPassword: true,
              focusNode: focusScope,
              enabled: !formState.loading,
              onChanged: formNotifier.passwordChanged,
              validator: formNotifier.validatePassword,
            ),
            const PasswordRulesWidget(),
            MSize.verticalSpaceLarge,
            const RememberMeCheckboxTile(),
            MSize.verticalSpaceXXLarge,
            MPrimaryButton(
              label: "Create Your Account",
              loading: formState.loading,
              onPressed: () {
                focusScope.unfocus();
                if (Form.of(formContext).validate()) {
                  formNotifier.registerPressed();
                }
              },
            ),
            MSize.verticalSpaceXXLarge,
            const GoogleDivider(title: "Create account with Google"),
            24.verticalSpace,
            const MGoogleButton(),
            44.verticalSpace,
            AuthRedirectionText(
              title: "Already have an account?",
              buttonText: "Log in",
              onPressed: () {
                if (hasOnboarded) {
                  context.push(Routes.login);
                } else {
                  context.replaceNamed(
                    Routes.login,
                    queryParameters: {
                      "implyLeading": context.canPop().toString(),
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
