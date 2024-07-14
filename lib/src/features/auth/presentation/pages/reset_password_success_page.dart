import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../router/router.dart';

class ResetPasswordSuccessPage extends StatelessWidget {
  const ResetPasswordSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.success.image(height: 240.r, width: 240.r),
          48.verticalSpace,
          const MText(
            'Success!',
            textAlign: TextAlign.center,
            style: MTextStyle.heading2Bold,
          ),
          MCore.small.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0).r,
            child: const MText(
              'Your password has been reset, Jim. Phew! That was a close one.',
              textAlign: TextAlign.center,
              maxLines: 3,
              style: MTextStyle.bodyRegular,
            ),
          ),
          48.verticalSpace,
          MPrimaryButton(
            label: 'Go Back to Log In',
            onPressed: () => context.go(Routes.login),
          ),
        ],
      ),
    );
  }
}
