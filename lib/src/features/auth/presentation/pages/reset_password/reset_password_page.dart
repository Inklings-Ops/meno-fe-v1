import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../../router/router.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      appBar: MAppBar.primary(title: "Reset Password"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24).r,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              24.verticalSpace,
              const MText(
                "Please enter the email associated with your account and we will send an email with instructions to reset your password.",
                maxLines: 3,
                style: MTextStyle.bodyRegular,
              ),
              MCore.xxLarge.verticalSpace,
              const MTextFormField(
                label: "Email Address",
                hint: "example@gmail.com",
                prefixIcon: MIcons.mail,
              ),
              MCore.xxLarge.verticalSpace,
              MPrimaryButton(
                label: "Send Instructions",
                onPressed: () => context.push(Routes.resetPwdOtp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
