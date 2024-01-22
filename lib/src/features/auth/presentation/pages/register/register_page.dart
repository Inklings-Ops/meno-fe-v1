import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../../dependency_injector/injector.dart';
import '../../../application//register/register_cubit.dart';
import 'register_form.dart';

class RegisterPage extends StatelessWidget {
  final bool implyLeading;

  const RegisterPage({super.key, this.implyLeading = true});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di<RegisterCubit>(),
      child: MScaffold(
        appBar: MAppBar.primary(
          title: 'New Account',
          backText: 'Go back',
          implyLeading: implyLeading,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24).r,
          child: const RegisterForm(),
        ),
      ),
    );
  }
}
