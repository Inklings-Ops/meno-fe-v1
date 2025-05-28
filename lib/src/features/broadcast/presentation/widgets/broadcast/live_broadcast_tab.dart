import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class LiveBroadcastTab extends HookWidget {
  const LiveBroadcastTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);

    return Column(
      key: const ValueKey('BroadcastTab'),
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              BroadcastControlButtons(),
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
