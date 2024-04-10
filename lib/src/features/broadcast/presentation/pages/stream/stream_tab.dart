import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../application/stream/stream_bloc.dart';
import '../../widgets/broadcast_about_tab.dart';
import '../../widgets/broadcast_artwork.dart';
import '../../widgets/broadcast_listening_tab.dart';
import '../../widgets/broadcast_status_widget.dart';
import '../../widgets/broadcast_title.dart';
import '../broadcast/broadcast_timer.dart';
import 'stream_controls.dart';

class StreamTab extends HookWidget {
  const StreamTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);

    return BlocBuilder<StreamBloc, StreamState>(
      builder: (context, state) {
        final broadcast = state.joinBroadcast.broadcast;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16).r,
              child: Column(
                children: [
                  BroadcastArtwork(imageUrl: broadcast.imageUrl),
                  MCore.small.verticalSpace,
                  const BroadcastTimer(),
                  MCore.small.verticalSpace,
                  BroadcastTitle(title: broadcast.title.get()!),
                  MCore.small.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MText(
                        broadcast.creator!.fullName,
                        style: MTextStyle.captionRegular,
                      ),
                      MCore.small.horizontalSpace,
                      const BroadcastStatusWidget(isStreaming: true),
                    ],
                  ),
                  24.verticalSpace,
                  StreamControls(broadcast: broadcast),
                  MCore.large.verticalSpace,
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 0).r,
                    constraints: const BoxConstraints(maxHeight: 32).r,
                    child: TabBar.secondary(
                      controller: tabController,
                      tabs: const [
                        Tab(text: 'Listening'),
                        Tab(text: 'About'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        BroadcastListeningTab(broadcast: broadcast),
                        BroadcastAboutTab(
                          description: broadcast.description?.get(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
