import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/auth/application/register/register_cubit.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

class RegisterNameField extends StatelessWidget {
  const RegisterNameField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (p, c) => p.fullName != c.fullName || p.loading != c.loading,
      builder: (context, state) => MTextFormField(
        label: 'Full Name',
        hint: 'Jim Halpert',
        prefixIcon: MIcons.user,
        enabled: !state.loading,
        onChanged: context.read<RegisterCubit>().fullNameChanged,
        validator: (_) => context.validator(state.fullName.value),
      ),
    );
  }
}
