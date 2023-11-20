import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../widgets/widgets.dart';

class EmailVerificationPage extends HookConsumerWidget {
  const EmailVerificationPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MScaffold(
      appBar: MAppBar.primary(title: "Verify Your Email"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24).r,
        child: Form(
          child: Builder(
            builder: (formContext) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const MText(
                  "OTP verification",
                  style: MTextStyle.heading2Medium,
                ),
                MCore.small.verticalSpace,
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Enter the 4-digit code we just sent to "),
                      TextSpan(
                        text: "jimhalpert26@gmail.com ",
                        style: MTextStyle.bodyBold,
                      ),
                      TextSpan(text: "to continue."),
                    ],
                  ),
                  style: MTextStyle.bodyRegular,
                ),
                MCore.xxLarge.verticalSpace,
                const MOtpField(),
                24.verticalSpace,
                const AuthRedirectionText(
                  title: "Didn’t receive code?",
                  buttonText: "Send again",
                ),
                MCore.xxLarge.verticalSpace,
                MPrimaryButton(label: "Continue", onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
