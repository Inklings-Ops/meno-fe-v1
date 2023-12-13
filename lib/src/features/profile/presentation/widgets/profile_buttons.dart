import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return SizedBox(
      height: 32.h,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
        child: Row(
          children: [
            Expanded(
              child: MPrimaryButton.icon(
                label: "Edit profile",
                icon: const Icon(MIcons.edit_05),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
            MCore.large.horizontalSpace,
            Expanded(
              child: MSecondaryButton.icon(
                label: "Share profile",
                icon: Icon(
                  MIcons.share,
                  color: colorScheme.onBackground,
                ),
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.outlineVariant3!),
                  foregroundColor: colorScheme.onBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
