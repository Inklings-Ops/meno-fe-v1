import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../widgets/widgets.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class EmailVerificationPage extends HookConsumerWidget {
  const EmailVerificationPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MScaffold(
      appBar: MAppBar.primary(title: "Verify Your Email"),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const MText(
                "OTP verification",
                style: MTextStyle.heading2Medium,
              ),
              MSize.verticalSpaceSmall,
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
              MSize.verticalSpaceXXLarge,
              const MOtpField(),
              24.verticalSpace,
              const AuthRedirectionText(
                title: "Didn’t receive code?",
                buttonText: "Send again",
              ),
              MSize.verticalSpaceXXLarge,
              MPrimaryButton(label: "Continue", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
