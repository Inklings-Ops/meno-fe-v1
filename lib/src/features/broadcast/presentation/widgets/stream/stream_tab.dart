import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class StreamTab extends HookWidget {
  const StreamTab({super.key});
  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16).radius,
          child: Column(
            children: [
              const _StreamArtwork(),
              $styles.spaces.verticalSmall,
              const BroadcastTimer(),
              $styles.spaces.verticalSmall,
              const _StreamTitle(),
              $styles.spaces.verticalSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _CreatorName(),
                  $styles.spaces.horizontalSmall,
                  const BroadcastStatusWidget(isStreaming: true),
                ],
              ),
              24.vSpace,
              const StreamControls(),
              $styles.spaces.verticalLarge,
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0).radius,
                constraints: const BoxConstraints(maxHeight: 32).radius,
                child: TabBar.secondary(
                  controller: tabController,
                  tabs: const [
                    Tab(text: 'Listening'),
                    Tab(text: 'About'),
                  ],
                ),
              ),
              24.vSpace,
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
    return BlocSelector<StreamBloc, StreamState, String>(
      selector: (state) => state.maybeWhen(
        orElse: () => 'Loading...',
        joinSuccess: (b) => b.creator!.fullName,
      ),
      builder: (context, fullName) => MText(
        fullName,
        style: $styles.text.captionRegular,
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
