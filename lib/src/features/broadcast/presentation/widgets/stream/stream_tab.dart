import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class StreamTab extends HookWidget {
  const StreamTab({super.key});
  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            children: [
              _StreamArtwork(),
              Spaces.verticalSmall,
              BroadcastTimer(),
              Spaces.verticalSmall,
              _StreamTitle(),
              Spaces.verticalSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CreatorName(),
                  Spaces.horizontalSmall,
                  BroadcastStatusWidget(isStreaming: true),
                ],
              ),
              Spaces.verticalXLarge,
              StreamControls(),
              Spaces.verticalLarge,
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

class _StreamArtwork extends StatelessWidget {
  const _StreamArtwork();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StreamBloc, StreamState, String?>(
      selector: (state) => state.whenOrNull(joinSuccess: (b) => b.imageUrl),
      builder: (context, url) => BroadcastArtworkWidget(imageUrl: url),
    );
  }
}

class _StreamTitle extends StatelessWidget {
  const _StreamTitle();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StreamBloc, StreamState, String>(
      selector: (state) => state.maybeWhen(
        orElse: () => 'Loading...',
        joinSuccess: (broadcast) => broadcast.title.getOr(),
      ),
      builder: (context, title) => BroadcastTitle(title: title),
    );
  }
}

class _CreatorName extends StatelessWidget {
  const _CreatorName();

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context)!;
    return BlocSelector<StreamBloc, StreamState, String>(
      selector: (state) => state.maybeWhen(
        orElse: () => 'Loading...',
        joinSuccess: (b) => b.creator!.fullName,
      ),
      builder: (context, fullName) => MText(
        fullName,
        style: textTheme.captionRegular,
      ),
    );
  }
}

class _BroadcastAboutTab extends StatelessWidget {
  const _BroadcastAboutTab();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StreamBloc, StreamState, String?>(
      selector: (state) => state.whenOrNull(
        joinSuccess: (broadcast) => broadcast.description?.getOr(),
      ),
      builder: (context, desc) => BroadcastAboutTab(description: desc),
    );
  }
}
