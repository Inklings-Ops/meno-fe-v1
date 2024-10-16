import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastTab extends HookWidget {
  const BroadcastTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);

    return Column(
      key: const ValueKey('BroadcastTab'),
      children: [
        const Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _BroadcastArtwork(),
                Spaces.verticalSmall,
                BroadcastTimer(),
                Spaces.verticalSmall,
                _BroadcastTitle(),
                Spaces.verticalSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _BroadcastCreator(),
                    Spaces.horizontalSmall,
                    BroadcastStatusWidget(),
                  ],
                ),
                Spaces.verticalXLarge,
                BroadcastControls(),
                Spaces.verticalLarge,
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                height: 40,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: TabBar.secondary(
                  controller: tabController,
                  tabs: const [
                    Tab(text: 'Listening'),
                    Tab(text: 'About'),
                  ],
                ),
              ),
              Spaces.verticalXLarge,
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: const [
                    BroadcastListeningTab(),
                    _BroadcastAboutTab(),
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

class _BroadcastAboutTab extends StatelessWidget {
  const _BroadcastAboutTab();

  @override
  Widget build(BuildContext context) {
    final broadcast = context.select((BroadcastBloc b) => b.state.broadcast);
    return BroadcastAboutTab(
      key: const ValueKey('BroadcastAboutTab'),
      description: broadcast.description?.getOr(),
    );
  }
}

class _BroadcastArtwork extends StatelessWidget {
  const _BroadcastArtwork();

  @override
  Widget build(BuildContext context) {
    final broadcast = context.select((BroadcastBloc b) => b.state.broadcast);
    return BroadcastArtworkWidget(
      key: const ValueKey('BroadcastArtworkWidget'),
      imageUrl: broadcast.imageUrl,
    );
  }
}

class _BroadcastCreator extends StatelessWidget {
  const _BroadcastCreator();

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    final broadcast = context.select((BroadcastBloc b) => b.state.broadcast);
    return MText(
      key: const ValueKey('BroadcastCreator'),
      broadcast.creator!.fullName,
      style: textTheme.captionRegular,
      color: MColorScheme.of(context)!.onDisabledContainer,
    );
  }
}

class _BroadcastTitle extends StatelessWidget {
  const _BroadcastTitle();

  @override
  Widget build(BuildContext context) {
    final broadcast = context.select((BroadcastBloc b) => b.state.broadcast);
    return BroadcastTitle(
      key: const ValueKey('BroadcastTitle'),
      title: broadcast.title.getOr(),
    );
  }
}
