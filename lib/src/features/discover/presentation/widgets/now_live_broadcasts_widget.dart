import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class NowLiveBroadcastsWidget extends StatelessWidget {
  const NowLiveBroadcastsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowLiveBloc, NowLiveState>(
      builder: (context, state) {
        switch (state) {
          case NowLiveLoadInProgress():
            return _List(broadcasts: fakeBroadcasts, loading: true);
          case NowLiveLoadMoreInProgress(:final broadcasts):
            return Column(
              children: [
                _List(broadcasts: broadcasts),
                Spaces.verticalXLarge,
                const MLoadingIndicator.box(),
              ],
            );
          case NowLiveLoadSuccess(:final broadcasts, :final hasMore):
            if (hasMore) return _List(broadcasts: broadcasts);
            return Column(
              children: [
                _List(broadcasts: broadcasts),
                Spaces.verticalXLarge,
                MText(
                  'You’ve reached the end 🎉',
                  style: MTextTheme.of(context).captionRegular,
                  color: MColorScheme.of(context).onBackgroundVariant,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
              ],
            );
          default:
            return const Padding(
              padding: EdgeInsets.only(top: 120),
              child: EmptyListWidget(),
            );
        }
      },
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.broadcasts, this.loading = false});
  final List<Broadcast?> broadcasts;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (broadcasts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 120),
        child: EmptyListWidget(),
      );
    }

    return Skeletonizer(
      enabled: loading,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 159.50 / 176,
        ),
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
        itemBuilder: (_, i) => LiveBroadcastCard(broadcast: broadcasts[i]!),
        itemCount: broadcasts.length,
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
