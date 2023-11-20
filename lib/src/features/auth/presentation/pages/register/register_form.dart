import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/auth/application/application.dart';

import '../../../../../router/router.dart';
import '../../../domain/domain.dart';
import '../../hooks/input_hooks.dart';
import '../../widgets/widgets.dart';

class RegisterForm extends HookConsumerWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IFullName name = useFullName();
    final nameFocusNode = useFocusNode();

    IEmail email = useEmail();
    final emailFocusNode = useFocusNode();

    IPassword password = usePassword();
    final passwordFocusNode = useFocusNode();

    final isOnboarded = ref.watch(authProvider.select((v) => v.isOnboarded));

    final register = useState<Future<dynamic>?>(null);

    final snapshot = useFuture(register.value);

    final isLoading = snapshot.connectionState == ConnectionState.waiting;

    return Form(
      child: Builder(
        builder: (formContext) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MTextFormField(
              label: "Full Name",
              hint: "Jim Halpert",
              prefixIcon: MIcons.user,
              focusNode: nameFocusNode,
              enabled: !isLoading,
              onChanged: (value) => name = IFullName(value),
              validator: (_) => name.value.fold(
                (e) => e.mapOrNull(empty: (_) => 'Full Name is required'),
                (_) => null,
              ),
            ),
            24.verticalSpace,
            MTextFormField(
              label: "Email Address",
              hint: "example@gmail.com",
              prefixIcon: MIcons.mail,
              focusNode: emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              enabled: !isLoading,
              onChanged: (value) => email = IEmail(value),
              validator: (_) => email.value.fold(
                (e) => e.mapOrNull(
                  invalidEmail: (_) => 'Please type a valid email address',
                  empty: (_) => 'Email is required',
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
              enabled: !isLoading,
              onChanged: (value) => password = IPassword(value),
              validator: (_) => password.value.fold(
                (e) => e.mapOrNull(
                  empty: (_) => 'Password is required',
                  invalidPassword: (_) => 'Please, type in a valid password',
                ),
                (_) => null,
              ),
            ),
            const PasswordRulesWidget(),
            MCore.large.verticalSpace,
            const RememberMeCheckboxTile(),
            MCore.xxLarge.verticalSpace,
            MPrimaryButton(
              label: "Create Your Account",
              loading: isLoading,
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (Form.of(formContext).validate()) {
                  register.value = ref.read(registerProvider(
                    email: email,
                    fullName: name,
                    password: password,
                  ).future);
                }
              },
            ),
            MCore.xxLarge.verticalSpace,
            const GoogleDivider(title: "Create account with Google"),
            24.verticalSpace,
            const MGoogleButton(),
            44.verticalSpace,
            AuthRedirectionText(
              title: "Already have an account?",
              buttonText: "Log in",
              onPressed: () {
                if (isOnboarded) {
                  context.replace(Routes.login);
                } else {
                  context.replace("/login?implyLeading=true");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
