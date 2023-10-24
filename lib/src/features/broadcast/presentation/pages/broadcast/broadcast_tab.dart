import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/presentation/pages/broadcast/broadcast_status_widget.dart';

import '../../../application/broadcast/broadcast_notifier.dart';
import '../../../domain/domain.dart';
import 'broadcast_about_tab.dart';
import 'broadcast_controls.dart';
import 'broadcast_listening_tab.dart';

class BroadcastTab extends HookWidget {
  const BroadcastTab({super.key});

  @override
  Widget build(BuildContext context) {
    final TabController tabController = useTabController(initialLength: 2);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            children: [
              const _BroadcastArtwork(),
              MSize.verticalSpaceSmall,
              const _BroadcastTimer(),
              MSize.verticalSpaceSmall,
              const _BroadcastTitle(),
              MSize.verticalSpaceSmall,
              const _BroadcastCreator(),
              24.verticalSpace,
              const BroadcastControls(),
              MSize.verticalSpaceLarge,
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                constraints: const BoxConstraints(maxHeight: 32),
                child: TabBar.secondary(
                  tabs: const [
                    Tab(text: "Listening"),
                    Tab(text: "About"),
                  ],
                  controller: tabController,
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: const [
                    BroadcastListeningTab(),
                    BroadcastAboutTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BroadcastArtwork extends ConsumerWidget {
  const _BroadcastArtwork({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double dimension = MediaQuery.sizeOf(context).width * 0.4;

    final String? imageUrl = ref.watch(
      broadcastNotifierProvider.select((v) => v.broadcast.imageUrl),
    );

    return Container(
      alignment: Alignment.center,
      height: dimension,
      width: dimension,
      child: MAvatar(
        radius: 48,
        isArtwork: true,
        url: imageUrl,
      ),
    );
  }
}

class _BroadcastCreator extends HookConsumerWidget {
  const _BroadcastCreator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Participant creator = ref.watch(
      broadcastNotifierProvider.select((v) => v.broadcast.creator),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MText(
          creator.fullName,
          style: MTextStyle.captionRegular,
        ),
        MSize.horizontalSpaceSmall,
        BroadcastStatusWidget(),
      ],
    );
  }
}

class _BroadcastTimer extends StatelessWidget {
  const _BroadcastTimer();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const MText(
          "00:30:36",
          style: MTextStyle.captionRegular,
        ),
        MSize.horizontalSpaceSmall,
        Container(
          width: 4,
          height: 4,
          decoration: const ShapeDecoration(
            color: Color(0xFF42526D),
            shape: OvalBorder(),
          ),
        ),
        MSize.horizontalSpaceSmall,
        const MText(
          "Started 5 mins ago",
          style: MTextStyle.captionRegular,
        ),
      ],
    );
  }
}

class _BroadcastTitle extends ConsumerWidget {
  const _BroadcastTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String title = ref.watch(
      broadcastNotifierProvider.select((v) => v.broadcast.title.get()!),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: MText(
        title,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: MTextStyle.subheadingBold,
      ),
    );
  }
}
