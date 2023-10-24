import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../application/broadcast/broadcast_notifier.dart';
import '../../../domain/domain.dart';

class BroadcastAboutTab extends ConsumerWidget
 {

  const BroadcastAboutTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Broadcast broadcast = ref.watch(broadcastNotifierProvider).broadcast;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          24.verticalSpace,
          const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(MIcons.menu_03, size: 16),
              MSize.horizontalSpaceSmall,
              MText("About Broadcast", style: MTextStyle.subheadingMedium),
            ],
          ),
          MSize.verticalSpaceLarge,
          if (broadcast.description?.get() != null)
            MText(broadcast.description!.get()!),
        ],
      ),
    );
  }
}
