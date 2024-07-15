import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../widgets.dart';

class RegisterForm extends HookWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const RegisterNameField(),
          24.verticalSpace,
          const RegisterEmail(),
          24.verticalSpace,
          const RegisterPasswordField(),
          const PasswordRulesWidget(),
          MCore.large.verticalSpace,
          const RememberMeCheckboxTile(),
          MCore.xxLarge.verticalSpace,
          const RegisterButton(),
        ],
      ),
    );
  }
}
