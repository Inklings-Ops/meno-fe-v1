import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../../router/router.dart';
import '../../../../onboarding/application/onboarding_cubit.dart';
import '../../../../onboarding/onboarding.dart';
import '../../../application/register/register_cubit.dart';
import '../../widgets/widgets.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        state.option.fold(
          () => null,
          (either) => either.fold(
            (failure) => context.showRegistrationError(failure),
            (_) => null,
          ),
        );
      },
      child: Form(
        child: Builder(
          builder: (formContext) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Name(),
              24.verticalSpace,
              const _Email(),
              24.verticalSpace,
              const _Password(),
              const PasswordRulesWidget(),
              MCore.large.verticalSpace,
              const RememberMeCheckboxTile(),
              MCore.xxLarge.verticalSpace,
              const _RegisterButton(),
              MCore.xxLarge.verticalSpace,
              const GoogleDivider(title: 'Create account with Google'),
              24.verticalSpace,
              const MGoogleButton(),
              44.verticalSpace,
              const _RedirectButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Email extends StatelessWidget {
  const _Email();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterCubit>();

    return BlocBuilder<RegisterCubit, RegisterState>(
      bloc: bloc,
      buildWhen: (p, c) => p.email != c.email,
      builder: (context, state) => MTextFormField(
        label: 'Email Address',
        hint: 'example@gmail.com',
        prefixIcon: MIcons.mail,
        keyboardType: TextInputType.emailAddress,
        enabled: !state.loading,
        onChanged: bloc.emailChanged,
        validator: bloc.validateEmail,
      ),
    );
  }
}

class _Name extends StatelessWidget {
  const _Name();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterCubit>();

    return BlocBuilder<RegisterCubit, RegisterState>(
      bloc: bloc,
      buildWhen: (p, c) => p.fullName != c.fullName,
      builder: (context, state) => MTextFormField(
        label: 'Full Name',
        hint: 'Jim Halpert',
        prefixIcon: MIcons.user,
        enabled: !state.loading,
        onChanged: bloc.fullNameChanged,
        validator: bloc.validateFullName,
      ),
    );
  }
}

class _Password extends StatelessWidget {
  const _Password();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterCubit>();

    return BlocBuilder<RegisterCubit, RegisterState>(
      bloc: bloc,
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
        title: 'Already have an account?',
        buttonText: 'Log in',
        onPressed: () {
          if (state == OnboardingState.completed) {
            context.replace(Routes.login);
          } else {
            context.replace(Routes.loginWithLeading);
          }
        },
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterCubit>();

    Future<void> register() async {
      FocusScope.of(context).unfocus();
      return await bloc.registerPressed();
    }

    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (p, c) => p.loading != c.loading,
      builder: (context, state) => MPrimaryButton(
        label: 'Create Your Account',
        loading: state.loading,
        onPressed: state.loading || !bloc.isValid ? null : register,
      ),
    );
  }
}
