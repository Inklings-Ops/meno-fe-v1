import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/router/routes.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

import '../widgets.dart';

class LoginForm extends HookWidget {
  final bool isPasswordOnly;

  const LoginForm({super.key, required this.isPasswordOnly});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isPasswordOnly) ...[
            UserAccountDetails(action: context.showSwitchAccountSheet),
            MCore.xxLarge.verticalSpace,
          ] else ...[
            LoginEmailField(isPwdOnly: isPasswordOnly),
            24.verticalSpace,
          ],
          const LoginPasswordField(),
          MCore.micro.verticalSpace,
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => context.push(Routes.resetPassword),
              child: const MText(
                'Forgot Password?',
                style: MTextStyle.captionMedium,
              ),
            ),
          ),
          MCore.xxLarge.verticalSpace,
          const LoginButton(),
        ],
      ),
    );
  }
}
