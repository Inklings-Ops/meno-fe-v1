import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/auth/application/login/login_cubit.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

class LoginPasswordField extends StatelessWidget {
  const LoginPasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (p, c) => p.password != c.password || p.loading || c.loading,
      builder: (context, state) => MTextFormField(
        label: 'Be Secure',
        hint: 'Enter your password',
        prefixIcon: MIcons.key,
        isPassword: true,
        enabled: !state.loading,
        onChanged: context.read<LoginCubit>().passwordChanged,
        validator: (_) => context.validator(state.password.value),
      ),
    );
  }
}
