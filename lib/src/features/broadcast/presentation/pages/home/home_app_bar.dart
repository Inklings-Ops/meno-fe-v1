import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/notifications/application/notifications_notifier.dart';

import '../../../../../router/router.dart';
import '../../../../auth/application/application.dart';
 

class HomeAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final hasNewNotification = useState<bool>(false);

    ref.listen(notificationsNotifierProvider, (previous, next) {
      if (previous?.value != next.value) {
        hasNewNotification.value = true;
      }
    });

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => state.maybeMap(
        orElse: () => const SizedBox(),
        authenticated: (v) => MAppBar.home(
          title: v.credentials.user.fullName.get()!,
          actions: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                MIconButton(
                  icon: const Icon(MIcons.bell),
                  size: 18.r,
                  onPressed: () {
                    hasNewNotification.value = false;
                    context.push(Routes.notifications);
                  },
                ),
                if (hasNewNotification.value)
                  const Positioned(
                    right: -3,
                    top: -3,
                    child: MBadge.small(),
                  ),
              ],
            ),
            24.horizontalSpace,
            InkWell(
              onTap: () => context.go(Routes.profile),
              child: MAvatar(radius: 16.r, url: v.credentials.user.imageUrl),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.h);
}
