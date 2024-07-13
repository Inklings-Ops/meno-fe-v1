import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../../router/router.dart';
import '../../../../broadcast/application/recently_live/recently_live_cubit.dart';
import '../../../../onboarding/application/onboarding_cubit.dart';
import '../../../../profile/application/application.dart';
import '../../../application/login/login_cubit.dart';
import '../../widgets/widgets.dart';

class LoginForm extends StatelessWidget {
  final bool isPasswordOnly;

  const LoginForm({super.key, required this.isPasswordOnly});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        state.option.fold(
          () => null,
          (either) => either.fold(
            (failure) => context.showLoginError(failure),
            (success) {
              context.read<MyProfileBloc>().add(const MyProfileEvent.fetch());
              context.read<RecentlyLiveCubit>().fetch();
            },
          ),
        );
      },
      child: Form(
        child: Builder(
          builder: (formContext) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isPasswordOnly) ...[
                UserAccountDetails(action: context.showSwitchAccountSheet),
                MCore.xxLarge.verticalSpace,
              ] else ...[
                _Email(isPasswordOnly),
                24.verticalSpace,
              ],
              const _Password(),
              MCore.micro.verticalSpace,
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => context.push(Routes.resetPassword),
                  child: const MText(
                    'Forgot Password?',
                    style: MTextStyle.captionMedium,
                  ),
                ),
              ),
              MCore.xxLarge.verticalSpace,
              const _LoginButton(),
              24.verticalSpace,
              const GoogleDivider(title: 'Login with Google'),
              24.verticalSpace,
              MGoogleButton(onPressed: () {}),
              149.verticalSpace,
              const _RedirectButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Email extends StatelessWidget {
  final bool isPasswordOnly;
  const _Email([this.isPasswordOnly = false]);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LoginCubit>();

    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (p, c) => p.email != c.email,
      builder: (context, state) => MTextFormField(
        label: 'Email Address',
        hint: 'example@gmail.com',
        prefixIcon: MIcons.mail,
        keyboardType: TextInputType.emailAddress,
        enabled: !state.loading,
        onChanged: isPasswordOnly ? null : (v) => bloc.emailChanged(v),
        validator: bloc.validateEmail,
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    Future<void> login() async {
      FocusScope.of(context).unfocus();
      return await context.read<LoginCubit>().login();
    }

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final isValid = state.email.isValid() && state.password.isValid();
        return MPrimaryButton(
          label: 'Log In',
          loading: state.loading,
          onPressed: !isValid ? null : login,
        );
      },
    );
  }
}

class _Password extends StatelessWidget {
  const _Password();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LoginCubit>();

    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (p, c) => p.password != c.password,
      builder: (context, state) => MTextFormField(
        label: 'Be Secure',
        hint: 'Enter your password',
        prefixIcon: MIcons.key,
        isPassword: true,
        enabled: !state.loading,
        onChanged: bloc.passwordChanged,
        validator: bloc.validatePassword,
      ),
    );
  }
}

class _RedirectButton extends StatelessWidget {
  const _RedirectButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) => AuthRedirectionText(
        title: 'Don’t have an account?',
        buttonText: 'Create an account',
        onPressed: () {
          if (state == OnboardingState.completed) {
            context.push(Routes.registerWithLeading);
          } else {
            context.replace(Routes.registerWithLeading);
          }
        },
      ),
    );
  }
}

// class _UserAccountDetails extends StatelessWidget {
//   const _UserAccountDetails();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthBloc, AuthState>(
//       buildWhen: (p, c) => p != c,
//       builder: (context, state) => state.maybeMap(
//         orElse: () => const SizedBox(),
//         authenticated: (value) => UserAccountDetails(
//           user: value.credentials.user,
//           action: context.showSwitchAccountSheet,
//         ),
//       ),
//     );
//   }
// }
