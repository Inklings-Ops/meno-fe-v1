import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/auth/application/login/login_cubit.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) => MPrimaryButton(
        label: 'Log In',
        loading: state.loading,
        disabled: state.loading || !state.isFormValid,
        onPressed: () {
          if (Form.of(context).validate()) {
            FocusScope.of(context).unfocus();
            context.read<LoginCubit>().login();
          }
        },
      ),
    );
  }
}
