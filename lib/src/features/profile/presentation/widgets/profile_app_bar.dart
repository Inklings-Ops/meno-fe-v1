import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return AppBar(
      leading: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: MCore.large).r,
          child: ColoredBox(
            color: colorScheme.secondary!,
            child: SizedBox(height: 30.h, width: 3.w),
          ),
        ),
      ),
      titleTextStyle: MTextStyle.heading3Bold,
      leadingWidth: 23.r,
      titleSpacing: 0.r,
      title: GestureDetector(
        onTap: () => context.showSwitchAccountSheet(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MText(name, color: colorScheme.onBackground),
            MCore.small.horizontalSpace,
            const Icon(MIcons.chevron_down, size: 24),
          ],
        ),
      ),
      actions: [
        MIconButton(
          icon: const Icon(MIcons.settings),
          color: colorScheme.primary,
        ),
        MCore.large.horizontalSpace,
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);
}
