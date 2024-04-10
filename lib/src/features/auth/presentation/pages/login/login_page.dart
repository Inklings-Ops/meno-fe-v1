import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../../dependency_injector/injector.dart';
import '../../../application/login/login_cubit.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  final bool implyLeading;
  final bool isPasswordOnly;

  const LoginPage({
    super.key,
    this.implyLeading = false,
    this.isPasswordOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<LoginCubit>(),
      child: MScaffold(
        appBar: MAppBar.primary(
          title: 'Log in',
          implyLeading: implyLeading,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24).r,
          child: LoginForm(isPasswordOnly: isPasswordOnly),
        ),
      ),
    );
  }
}
