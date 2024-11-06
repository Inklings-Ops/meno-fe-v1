import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class LiveStreamActivityCard extends StatelessWidget {
  const LiveStreamActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final broadcast = context.select((StreamBloc bloc) => bloc.state.broadcast);
    
    return BlocBuilder<MenoBloc, MenoState>(
      builder: (context, menoState) => menoState.maybeWhen(
        orElse: () => const SizedBox(),
        streaming: () => ActivityCard(
          badgeTitle: 'Now Streaming',
          broadcast: broadcast,
          actionButtonLabel: 'Leave',
          action: () => onBroadcastLeave(context),
          onTap: () => router.push<void>(Routes.stream),
        ),
        reconnecting: () => ActivityCard(
          badgeTitle: 'Reconnecting',
          broadcast: broadcast,
          actionButtonLabel: 'Leave',
          onTap: () => router.push<void>(Routes.stream),
        ),
      ),
    );
  }

  void onBroadcastLeave(BuildContext context) {
    final bloc = context.read<StreamBloc>();
    context.showLeaveBroadcastDialog().then((value) {
      if (value == null || value == false) return;
      return bloc.add(StreamLeavePressed(bloc.state.broadcast.id));
    });
  }
}
