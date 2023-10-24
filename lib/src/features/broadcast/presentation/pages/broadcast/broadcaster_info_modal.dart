import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/application/broadcast/broadcast_notifier.dart';

import '../../../domain/domain.dart';
import 'broadcast_status_widget.dart';

class BroadcasterInfoModal extends ConsumerWidget {
  const BroadcasterInfoModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MColorScheme colorScheme = MColorScheme.of(context)!;
    final BroadcastState broadcastState = ref.watch(broadcastNotifierProvider);
    final Broadcast broadcast = broadcastState.broadcast;

    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MAvatar(radius: 48, isArtwork: true, url: broadcast.imageUrl),
          MSize.verticalSpaceSmall,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: MText(
              broadcast.title.get()!,
              style: MTextStyle.subheadingBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          MSize.verticalSpaceMicro,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MText(
                  broadcast.creator.fullName,
                  style: MTextStyle.captionRegular,
                ),
                MSize.horizontalSpaceSmall,
                const BroadcastStatusWidget(),
              ],
            ),
          ),
          24.verticalSpace,
          ListTile(
            leading: const Icon(MIcons.share, size: 20),
            title: const MText("Share"),
            titleTextStyle: MTextStyle.bodyRegular,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: MCore.medium,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(MIcons.link_02, size: 20),
            title: const MText("Copy Link"),
            titleTextStyle: MTextStyle.bodyRegular,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: MCore.medium,
            ),
            onTap: () {},
          ),
          if (broadcastState.status == Status.offAir)
            ListTile(
              leading: Icon(MIcons.trash, size: 20, color: colorScheme.error),
              title: const MText("Delete Broadcast"),
              titleTextStyle: MTextStyle.bodyRegular,
              textColor: colorScheme.error,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: MCore.medium,
              ),
              onTap: () {
                final id = ref.read(broadcastNotifierProvider).broadcast.id;
                ref.read(broadcastNotifierProvider.notifier).deletePressed(id);
                context.popRoute();
              },
            ),
        ],
      ),
    );
  }
}
