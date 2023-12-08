import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../../router/router.dart';
import '../../../../auth/application/auth/auth_notifier.dart';
import '../../../../auth/domain/domain.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User user = ref.read(userProvider);

    return MAppBar.home(
      title: user.fullName.get()!,
      actions: [
        MIconButton(
          icon: const Icon(MIcons.bell),
          size: 18.r,
          onPressed: () => context.push(Routes.notifications),
        ),
        24.horizontalSpace,
        InkWell(
          onTap: () => context.go(Routes.profile),
          child: MAvatar(radius: 16.r, url: user.imageUrl),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.h);
}
