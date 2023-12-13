import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class AccountUpgradeSection extends StatelessWidget {
  const AccountUpgradeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.h,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
        child: Row(
          children: [
            MTag(title: "FREE ACCOUNT", height: 24.r),
            MCore.large.horizontalSpace,
            MTextButton(
              label: "Upgrade to Premium",
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                textStyle: MTextStyle.captionMedium.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
