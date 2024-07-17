import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastAboutTab extends StatelessWidget {
  final String? description;
  const BroadcastAboutTab({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(MIcons.menu_03, size: 16.r),
              MCore.small.horizontalSpace,
              const MText(
                'About Broadcast',
                style: MTextStyle.subheadingMedium,
              ),
            ],
          ),
          MCore.large.verticalSpace,
          if (description != null)
            MText(
              description!,
              color: MColorScheme.of(context)!.onDisabledContainer,
            ),
        ],
      ),
    );
  }
}
