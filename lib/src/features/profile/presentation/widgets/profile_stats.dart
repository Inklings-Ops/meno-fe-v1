import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../domain/domain.dart';
import 'profile_stat_item.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key, required this.stats});

  final UserStats? stats;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 239.w,
      height: 46.h,
      child: Row(
        children: [
          2.horizontalSpace,
          ProfileStatItem(title: 'Broadcasts', count: stats?.broadcasts),
          MCore.large.horizontalSpace,
          ProfileStatItem(title: 'Subscribers', count: stats?.subscribers),
          MCore.large.horizontalSpace,
          ProfileStatItem(title: 'Subscriptions', count: stats?.subscriptions),
          2.horizontalSpace,
        ],
      ),
    );
  }
}
