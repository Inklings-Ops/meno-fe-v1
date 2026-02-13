import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/applications/live_session_manager.dart';
import 'package:meno/features/broadcast/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class LiveBroadcastTab extends WatchingStatefulWidget {
  const LiveBroadcastTab({super.key});

  @override
  State<LiveBroadcastTab> createState() => _LiveBroadcastTabState();
}

class _LiveBroadcastTabState extends State<LiveBroadcastTab>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final manager = di<LiveSessionManager>();
    final broadcast = manager.broadcast;

    final time = watchValue((LiveSessionManager m) => m.timer.formattedTime);
    final timeAgo = watchValue((LiveSessionManager m) => m.timer.timeAgo);
    final isRunning = watchValue((LiveSessionManager m) => m.timer.isRunning);

    final status = watchValue((LiveSessionManager m) => m.liveStatus);

    return Column(
      key: const ValueKey('BroadcastTab'),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BroadcastArtworkWidget(imageUrl: broadcast.imageUrl),
              Spaces.verticalSmall,
              BroadcastTimerWidget(
                formattedTime: time,
                isRunning: isRunning,
                timeAgo: timeAgo,
              ),
              Spaces.verticalSmall,
              BroadcastTitleWidget(title: broadcast.title.getOrCrash()),
              Spaces.verticalSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BroadcastCreatorWidget(
                    creatorName: broadcast.effectiveCreatorName.getOrCrash(),
                  ),
                  Spaces.horizontalSmall,
                  BroadcastStatusWidget(status: status),
                ],
              ),
              Spaces.verticalXLarge,
              const BroadcastControlButtons(),
            ],
          ),
        ),
        SizedBox(
          height: 40,
          child: Padding(
            padding: const EdgeInsets.only(top: Insets.sm),
            child: TabBar.secondary(
              controller: tabController,
              tabs: const [
                Tab(text: 'Listening'),
                Tab(text: 'About'),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: const [
              BroadcastListeningTab(key: Key('LiveBroadcastParticipantsTab')),
              BroadcastAboutTab(key: Key('LiveBroadcastAboutTab')),
            ],
          ),
        ),
      ],
    );
  }
}
