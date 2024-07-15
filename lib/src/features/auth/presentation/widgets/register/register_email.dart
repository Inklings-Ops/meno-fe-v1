import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/auth/application/register/register_cubit.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

class RegisterEmail extends StatelessWidget {
  const RegisterEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (p, c) => p.email != c.email || p.loading != c.loading,
      builder: (context, state) => MTextFormField(
        label: 'Email Address',
        hint: 'example@gmail.com',
        prefixIcon: MIcons.mail,
        keyboardType: TextInputType.emailAddress,
        enabled: !state.loading,
        onChanged: context.read<RegisterCubit>().emailChanged,
        validator: (_) => context.validator(state.email.value),
      ),
    );
  }
}
