import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../../router/router.dart';
import '../../widgets/widgets.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class ResetPasswordOtpVerificationPage extends StatelessWidget {
  const ResetPasswordOtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar.primary(title: "Reset Password"),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              24.verticalSpace,
              const MText("OTP Verification", style: MTextStyle.heading2Medium),
              MSize.verticalSpaceSmall,
              const MText(
                "Enter the 4-digit code we just sent to jimhalpert26@gmail.com to continue",
                maxLines: 3,
                style: MTextStyle.bodyRegular,
              ),
              MSize.verticalSpaceXXLarge,
              const MOtpField(),
              24.verticalSpace,
              const AuthRedirectionText(
                title: "Didn't receive code?",
                buttonText: "Send again",
              ),
              MSize.verticalSpaceXXLarge,
              MPrimaryButton(
                label: "Continue",
                onPressed: () => context.push(Routes.createNewPassword),
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
