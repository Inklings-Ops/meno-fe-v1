import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../application/broadcast/broadcast_notifier.dart';
import '../../domain/domain.dart';
import 'broadcast_status_widget.dart';

class BroadcastInfoModal extends ConsumerWidget {
  final bool isBroadcasting;
  final Broadcast broadcast;

  const BroadcastInfoModal({
    super.key,
    required this.broadcast,
    this.isBroadcasting = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = MColorScheme.of(context)!;

    final broadcastState = ref.watch(broadcastNotifierProvider);

    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MAvatar(radius: 48.r, url: broadcast.imageUrl),
          MCore.small.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0).r,
            child: MText(
              broadcast.title.get()!,
              style: MTextStyle.subheadingBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          MCore.micro.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0).r,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MText(
                  broadcast.creator!.fullName,
                  style: MTextStyle.captionRegular,
                ),
                MCore.small.horizontalSpace,
                const BroadcastStatusWidget(),
              ],
            ),
          ),
          24.verticalSpace,
          if (!isBroadcasting) ...[
            const MModalListTile(
              leading: Icon(MIcons.arrow_narrow_down_left),
              title: "Minimize Stream",
            ),
            const MModalListTile(
              leading: Icon(MIcons.user_minus_01),
              title: "Unsubscribe",
            ),
          ],
          const MModalListTile(
            leading: Icon(MIcons.share),
            title: "Share",
          ),
          const MModalListTile(
            leading: Icon(MIcons.link_02),
            title: "Copy Link",
          ),
          if (broadcastState.status == Status.offAir && isBroadcasting)
            MModalListTile(
              leading: Icon(MIcons.trash, color: colorScheme.error),
              title: "Delete Broadcast",
              titleColor: colorScheme.error,
              onTap: () {
                final id = ref.read(broadcastNotifierProvider).broadcast.id;
                ref.read(broadcastNotifierProvider.notifier).deletePressed(id);
                context.pop();
              },
            ),
          24.verticalSpace,
        ],
      ),
    );
  }
}
