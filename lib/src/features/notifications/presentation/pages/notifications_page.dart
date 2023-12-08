import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/notifications/presentation/pages/subscribe_notification_card.dart';

import 'live_notification_card.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MScaffold(
      appBar: const _AppBar(),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              24.verticalSpace,
              const MText("Today", style: MTextStyle.captionMedium),
              MCore.large.verticalSpace,
              ListView.separated(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) => const LiveNotificationCard(),
                separatorBuilder: (context, i) => MCore.large.verticalSpace,
                itemCount: 2,
              ),
              MCore.xxLarge.verticalSpace,
              const MText("This week", style: MTextStyle.captionMedium),
              MCore.large.verticalSpace,
              ListView.separated(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) => const SubscribeNotificationCard(),
                separatorBuilder: (context, i) => MCore.large.verticalSpace,
                itemCount: 2,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: MCore.small,
            ).r,
            child: const MBackButton.withText(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: MCore.small).r,
            child: const MHeader(title: "Notifications"),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(86.h);
}
