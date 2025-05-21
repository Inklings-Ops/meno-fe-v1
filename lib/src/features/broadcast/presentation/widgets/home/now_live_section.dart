import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class NowLiveSection extends StatelessWidget {
  const NowLiveSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spaces.verticalXXXLarge,
        MHeader(
          title: 'Now Live',
          action: InkWell(
            onTap: () => context.pushNamed(
              'Broadcasts',
              queryParameters: {
                'type': BroadcastsPageType.now.name,
                'sort-by': 'startTime',
                'order-by': OrderBy.ASC.name,
                'end-time-exists': 'false',
                'start-time-exists': 'true',
                'include': 'totalListeners',
                'status': 'active',
              },
            ),
            child: MText('See all', color: colors.onBackgroundVariant),
          ),
        ),
        const SizedBox(height: 24),
        LimitedBox(
          maxHeight: 184,
          child: BlocBuilder<NowLiveBloc, NowLiveState>(
            builder: (context, state) {
              switch (state) {
                case NowLiveLoadInProgress():
                  return _List(broadcasts: fakeBroadcasts, loading: true);
                case NowLiveLoadSuccess(:final broadcasts):
                  return _List(broadcasts: broadcasts);
                case NowLiveLoadFailure():
                  return const EmptyListWidget();
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.broadcasts, this.loading = false});
  final List<Broadcast?> broadcasts;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (broadcasts.isEmpty) return const EmptyListWidget();

    return Skeletonizer(
      enabled: loading,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
        separatorBuilder: (context, i) => const SizedBox(width: 24),
        itemCount: broadcasts.length,
        itemBuilder: (_, i) => LiveBroadcastCard(broadcast: broadcasts[i]!),
        primary: false,
        shrinkWrap: true,
      ),
    );
  }
}
