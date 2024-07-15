import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/auth/application/login/login_cubit.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

class LoginEmailField extends StatelessWidget {
  final bool isPwdOnly;
  const LoginEmailField({super.key, this.isPwdOnly = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (p, c) => p.email != c.email || p.loading != c.loading,
      builder: (context, state) => MTextFormField(
        label: 'Email Address',
        hint: 'example@gmail.com',
        prefixIcon: MIcons.mail,
        keyboardType: TextInputType.emailAddress,
        enabled: !state.loading,
        onChanged: isPwdOnly ? null : context.read<LoginCubit>().emailChanged,
        validator: (_) => context.validator(state.email.value),
      ),
    );
  }
}
