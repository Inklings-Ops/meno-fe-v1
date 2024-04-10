import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    this.title,
    required this.actionTitle,
    required this.action,
  });

  final String? title;
  final String actionTitle;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return Container(
      margin: const EdgeInsets.only(top: 40).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Assets.images.liveForYou.image(height: 120.r, width: 120.r),
          MText(
            title ?? 'No broadcasts published yet',
            style: MTextStyle.captionMedium,
            textAlign: TextAlign.center,
          ),
          MCore.large.verticalSpace,
          SizedBox(
            height: 32.h,
            child: MSecondaryButton.icon(
              label: 'View $actionTitle',
              icon: Icon(
                MIcons.share,
                color: colorScheme.onBackground,
              ),
              onPressed: action,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: MCore.large,
                  vertical: MCore.small,
                ).r,
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
    );
  }
}
