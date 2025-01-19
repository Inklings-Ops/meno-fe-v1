import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/socket/bloc/socket_bloc.dart';

class NowLiveSection extends StatelessWidget {
  const NowLiveSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final bloc = context.read<LiveBroadcastsBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spaces.verticalXXXLarge,
        MHeader(
          title: 'Now Live',
          action: InkWell(
            onTap: () => context.push(Routes.nowLive),
            child: MText('See all', color: colors.onBackgroundVariant),
          ),
        ),
        const SizedBox(height: 24),
        BlocListener<SocketBloc, SocketState>(
          listener: (context, state) {
            state.whenOrNull(
              newBroadcast: (data) => bloc.add(NewBroadcastReceived(data)),
              endedBroadcast: (data) => bloc.add(EndedBroadcastReceived(data)),
            );
          },
          child: LimitedBox(
            maxHeight: 184,
            child: BlocBuilder<LiveBroadcastsBloc, LiveBroadcastsState>(
              builder: (context, state) => state.maybeWhen(
                orElse: EmptyListWidget.new,
                loading: () => _List(broadcasts: fakeBroadcasts, loading: true),
                loaded: (broadcasts) => _List(broadcasts: broadcasts),
              ),
            ),
          ),
        ),
      ],
    );
  }
}



class _List extends StatelessWidget {
  const _List({required this.broadcasts, super.key, this.loading = false});
  final List<Broadcast?> broadcasts;
  final bool loading;

  @override
  Widget build(BuildContext context) {
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
