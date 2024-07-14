import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../router/router.dart';


class ResetPasswordPage extends HookWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    return MScaffold(
      appBar: MAppBar.primary(title: 'Reset Password'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24).r,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              24.verticalSpace,
              const MText(
                'Please enter the email associated with your account and we will send an email with instructions to reset your password.',
                maxLines: 3,
                style: MTextStyle.bodyRegular,
              ),
              MCore.xxLarge.verticalSpace,
              const MTextFormField(
                label: 'Email Address',
                hint: 'example@gmail.com',
                prefixIcon: MIcons.mail,
              ),
              MCore.xxLarge.verticalSpace,
              MPrimaryButton(
                label: 'Send Instructions',
                onPressed: () => context.push(Routes.resetPwdOtp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
