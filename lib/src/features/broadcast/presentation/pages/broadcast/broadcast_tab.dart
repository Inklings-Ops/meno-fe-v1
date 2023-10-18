import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import 'broadcast_about_tab.dart';
import 'broadcast_controls.dart';
import 'broadcast_listening_tab.dart';

class BroadcastTab extends HookConsumerWidget {
  const BroadcastTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TabController tabController = useTabController(initialLength: 2);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 144,
                width: 144,
                child: const MAvatar(radius: 48, isArtwork: true),
              ),
              MSize.verticalSpaceSmall,
              Row(
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
              ),
              MSize.verticalSpaceSmall,
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: MText(
                  "Deeper UK: Who is Jesus, Who are you? (Grand Finale)",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: MTextStyle.subheadingBold,
                ),
              ),
              MSize.verticalSpaceSmall,
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MText(
                    "Celebration Church Int’l",
                    style: MTextStyle.captionRegular,
                  ),
                  MSize.horizontalSpaceSmall,
                  MBadge.live(),
                ],
              ),
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
