import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/broadcast.dart';
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
    final broadcast = watchValue((LiveSessionManager m) => m.broadcast);
    final time = watchValue((LiveSessionManager m) => m.timer.formattedTime);
    final timeAgo = watchValue((LiveSessionManager m) => m.timer.timeAgo);
    final isRunning = watchValue((LiveSessionManager m) => m.timer.isRunning);

    return Column(
      key: const ValueKey('LiveBroadcastTab'),
      children: [
        Padding(
          padding: const .fromLTRB(16, 24, 16, 16),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              BroadcastArtworkWidget(imageUrl: broadcast.imageUrl),
              Spaces.verticalSmall,
              BroadcastTimerWidget(
                formattedTime: time,
                isRunning: isRunning,
                timeAgo: timeAgo,
              ),
              Spaces.verticalSmall,
              BroadcastTitleWidget(title: broadcast.title),
              Spaces.verticalSmall,
              Row(
                mainAxisAlignment: .center,
                children: [
                  BroadcastCreatorWidget(name: broadcast.hostName),
                  Spaces.horizontalSmall,
                  const BroadcastStatusWidget(),
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
            padding: const .only(top: Insets.sm),
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
