import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../../router/router.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

@RoutePage()
class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      appBar: MAppBar.primary(title: "Reset Password"),
      isScrollable: true,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              24.verticalSpace,
              const MText(
                "Please enter the email associated with your account and we will send an email with instructions to reset your password.",
                maxLines: 3,
                style: MTextStyle.bodyRegular,
              ),
              MSize.verticalSpaceXXLarge,
              const MTextFormField(
                label: "Email Address",
                hint: "example@gmail.com",
                prefixIcon: MIcons.mail,
              ),
              MSize.verticalSpaceXXLarge,
              MPrimaryButton(
                label: "Send Instructions",
                onPressed: () {
                  context.navigateTo(const ResetPasswordOtpVerificationRoute());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
