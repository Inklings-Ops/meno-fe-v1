import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/onboarding/application/onboarding_provider.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../../router/router.dart';
import '../../../application/application.dart';
import '../../../domain/domain.dart';
import '../../widgets/widgets.dart';

class LoginForm extends HookConsumerWidget {
  final bool isPasswordOnly;

  const LoginForm({super.key, required this.isPasswordOnly});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnboarded = ref.watch(onboardingProvider).isOnboarded;

    final user = ref.watch(authProvider.select((v) => v.user));

    final isLoading = ref.watch(authProvider.select((v) => v.loading));

    final email = useState<IEmail>(isPasswordOnly ? user.email : IEmail(""));
    final emailFocusNode = useFocusNode();

    final password = useState<IPassword>(IPassword("", isLogin: true));
    final passwordFocusNode = useFocusNode();

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
              MCore.xxLarge.verticalSpace,
            ] else ...[
              MTextFormField(
                label: "Email Address",
                hint: "example@gmail.com",
                prefixIcon: MIcons.mail,
                keyboardType: TextInputType.emailAddress,
                enabled: !isLoading,
                focusNode: emailFocusNode,
                onChanged: (v) => email.value = IEmail(v),
                validator: (_) => email.value.value.fold(
                  (e) => e.mapOrNull(
                    invalidEmail: (_) => 'Please type a valid email address',
                    empty: (_) => 'Email is required',
                  ),
                  (_) => null,
                ),
              ),
              24.verticalSpace,
            ],
            MTextFormField(
              label: "Be Secure",
              hint: "Enter your password",
              prefixIcon: MIcons.key,
              isPassword: true,
              enabled: !isLoading,
              focusNode: passwordFocusNode,
              onChanged: (v) => password.value = IPassword(v, isLogin: true),
              validator: (_) => password.value.value.fold(
                (e) => e.mapOrNull(
                  empty: (_) => 'Password is required',
                  invalidPassword: (_) => 'Please, type in a valid password',
                ),
                (_) => null,
              ),
            ),
            MCore.micro.verticalSpace,
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
            MCore.xxLarge.verticalSpace,
            MPrimaryButton(
              label: "Log In",
              loading: isLoading,
              onPressed: () {
                if (Form.of(formContext).validate()) {
                  FocusScope.of(context).unfocus();
                  ref.read(authProvider.notifier).login(
                        email.value,
                        password.value,
                      );
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
                if (isOnboarded) {
                  context.push(Routes.registerWithLeading);
                } else {
                  context.replace(Routes.registerWithLeading);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
