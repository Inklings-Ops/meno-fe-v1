import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/broadcast/broadcast.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastTabWidget extends WatchingWidget {
  const BroadcastTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final broadcast = watchValue((LiveSessionManager m) => m.broadcast);
    final time = watchValue((LiveSessionManager m) => m.timer.formattedTime);
    final timeAgo = watchValue((LiveSessionManager m) => m.timer.timeAgo);
    final isRunning = watchValue((LiveSessionManager m) => m.timer.isRunning);

    return DefaultTabController(
      length: 2,
      child: Column(
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
          const SizedBox(
            height: 40,
            child: Padding(
              padding: EdgeInsets.only(top: Insets.sm),
              child: TabBar.secondary(
                tabs: [
                  Tab(text: 'Listening'),
                  Tab(text: 'About'),
                ],
              ),
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [BroadcastListeningTab(), BroadcastAboutTab()],
            ),
          ),
        ],
      ),
    );
  }
}
