import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../../router/router.dart';
import '../../../../auth/application/application.dart';
 

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {

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
                   
                    context.push(Routes.notifications);
                  },
                ),
                // if (hasNewNotification.value)
                //   const Positioned(
                //     right: -3,
                //     top: -3,
                //     child: MBadge.small(),
                //   ),
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
