import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/auth/application/register/register_cubit.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (p, c) => p.loading != c.loading,
      builder: (context, state) => MPrimaryButton(
        label: 'Create Your Account',
        loading: state.loading,
        disabled: state.loading || !state.isFormValid,
        onPressed: () {
          if (Form.of(context).validate()) {
            FocusScope.of(context).unfocus();
            context.read<RegisterCubit>().registerPressed();
          }
        },
      ),
    );
  }
}
