import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';

class LiveBroadcastActivityCard extends StatelessWidget {
  const LiveBroadcastActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final broadcast = context.select(
      (BroadcastBloc bloc) => bloc.state.broadcast,
    );

    return BlocBuilder<MenoBloc, MenoState>(
      builder: (context, menoState) => menoState.maybeWhen(
        orElse: () => const SizedBox(),
        live: () => ActivityCard(
          badgeTitle: 'Now Live',
          broadcast: broadcast,
          actionButtonLabel: 'End',
          action: () => onBroadcastEnd(context),
          onTap: () => router.push<void>(Routes.broadcast),
        ),
        reconnecting: () => ActivityCard(
          badgeTitle: 'Reconnecting',
          broadcast: broadcast,
          actionButtonLabel: 'End',
          onTap: () => router.push<void>(Routes.broadcast),
        ),
      ),
    );
  }

  void onBroadcastEnd(BuildContext context) {
    final bloc = context.read<BroadcastBloc>();
    context.showEndBroadcastDialog().then((value) {
      if (value == null || value == false) return;
      return bloc.add(BroadcastEndPressed(bloc.state.broadcast.id));
    });
  }
}
