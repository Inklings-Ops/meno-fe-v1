import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../../router/router.dart';
import '../../widgets/widgets.dart';

class ResetPasswordOtpVerificationPage extends StatelessWidget {
  const ResetPasswordOtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      appBar: MAppBar.primary(title: "Reset Password"),
      body: Form(
        child: Builder(
          builder: (formContext) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                24.verticalSpace,
                const MText(
                  "OTP Verification",
                  style: MTextStyle.heading2Medium,
                ),
                MCore.small.verticalSpace,
                const MText(
                  "Enter the 4-digit code we just sent to jimhalpert26@gmail.com to continue",
                  maxLines: 3,
                  style: MTextStyle.bodyRegular,
                ),
                MCore.xxLarge.verticalSpace,
                const MOtpField(),
                24.verticalSpace,
                const AuthRedirectionText(
                  title: "Didn't receive code?",
                  buttonText: "Send again",
                ),
                MCore.xxLarge.verticalSpace,
                MPrimaryButton(
                  label: "Continue",
                  onPressed: () => context.push(Routes.createNewPassword),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
