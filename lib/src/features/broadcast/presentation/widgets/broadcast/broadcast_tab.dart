import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class BroadcastTab extends HookWidget {
  const BroadcastTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);

    return Column(
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
                    _BroadcastListeningTab(),
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
    return BlocSelector<BroadcastBloc, BroadcastState, String?>(
      selector: (state) => state.maybeWhen(
        orElse: () => null,
        initial: (broadcast) => broadcast.description?.getOr(),
        startSuccess: (broadcast, muted) => broadcast.description?.getOr(),
      ),
      builder: (context, desc) => BroadcastAboutTab(description: desc),
    );
  }
}

class _BroadcastArtwork extends StatelessWidget {
  const _BroadcastArtwork();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BroadcastBloc, BroadcastState, String?>(
      bloc: context.read<BroadcastBloc>(),
      selector: (state) => state.maybeWhen(
        orElse: () => null,
        initial: (broadcast) => broadcast.imageUrl,
        startSuccess: (broadcast, muted) => broadcast.imageUrl,
      ),
      builder: (context, url) => BroadcastArtworkWidget(imageUrl: url),
    );
  }
}

class _BroadcastCreator extends StatelessWidget {
  const _BroadcastCreator();

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return BlocSelector<BroadcastBloc, BroadcastState, String>(
      bloc: context.read<BroadcastBloc>(),
      selector: (state) => state.maybeWhen(
        orElse: () => 'Loading...',
        initial: (broadcast) => broadcast.creator!.fullName,
        startSuccess: (broadcast, muted) => broadcast.creator!.fullName,
      ),
      builder: (context, fullName) => MText(
        fullName,
        style: textTheme.captionRegular,
        color: MColorScheme.of(context)!.onDisabledContainer,
      ),
    );
  }
}

class _BroadcastListeningTab extends StatelessWidget {
  const _BroadcastListeningTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BroadcastBloc, BroadcastState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const MLoadingIndicator.box(),
        initial: (broadcast) => const BroadcastListeningTab(),
        startSuccess: (broadcast, mute) => const BroadcastListeningTab(),
      ),
    );
  }
}

class _BroadcastTitle extends StatelessWidget {
  const _BroadcastTitle();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BroadcastBloc, BroadcastState, String>(
      selector: (state) => state.maybeWhen(
        orElse: () => 'Loading...',
        initial: (broadcast) => broadcast.title.getOr(),
        startSuccess: (broadcast, muted) => broadcast.title.getOr(),
      ),
      builder: (context, title) => BroadcastTitle(title: title),
    );
  }
}
