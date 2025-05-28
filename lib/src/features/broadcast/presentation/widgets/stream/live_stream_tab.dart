import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class LiveStreamTab extends HookWidget {
  const LiveStreamTab({super.key});
  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            children: [
              BroadcastArtworkWidget(key: Key('LiveBroadcastArtwork')),
              Spaces.verticalSmall,
              BroadcastTimerWidget(key: Key('LiveBroadcastTimer')),
              Spaces.verticalSmall,
              BroadcastTitleWidget(key: Key('LiveBroadcastTitle')),
              Spaces.verticalSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BroadcastCreatorWidget(key: Key('LiveBroadcastCreator')),
                  Spaces.horizontalSmall,
                  BroadcastStatusWidget(key: Key('LiveBroadcastStatus')),
                ],
              ),
              Spaces.verticalXLarge,
              StreamControlButtons(key: Key('LiveStreamControls')),
              Spaces.verticalLarge,
            ],
          ),
        ),
        SizedBox(
          height: 40,
          child: Padding(
            padding: const EdgeInsets.only(top: Insets.sm),
            child: TabBar.secondary(
              controller: tabController,
              tabs: const [Tab(text: 'Listening'), Tab(text: 'About')],
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
