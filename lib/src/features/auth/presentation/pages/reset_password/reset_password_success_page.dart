import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../../router/router.dart';

class ResetPasswordSuccessPage extends StatelessWidget {
  const ResetPasswordSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.images.success.image(height: 240, width: 240),
            48.verticalSpace,
            const MText("Success!",
                textAlign: TextAlign.center, style: MTextStyle.heading2Bold),
            MSize.verticalSpaceSmall,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: MText(
                "Your password has been reset, Jim. Phew! That was a close one.",
                textAlign: TextAlign.center,
                maxLines: 3,
                style: MTextStyle.bodyRegular,
              ),
            ),
            48.verticalSpace,
            MPrimaryButton(
              label: "Go Back to Log In",
              onPressed: () => context.go(Routes.login),
            ),
          ],
        ),
      ),
    );
  }
}
