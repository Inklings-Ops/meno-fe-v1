import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/application/live_broadcasts/live_broadcasts_bloc.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../application/live_participants/live_participants_cubit.dart';
import '../../../domain/domain.dart';
import '../../widgets/broadcast_list_widget.dart';
import '../stream/stream_modal.dart';

class NowLive extends StatelessWidget {
  const NowLive({super.key});

  @override
  Widget build(BuildContext context) {
    // final liveBroadcasts = ref.watch(liveBroadcastsProvider);

    // return liveBroadcasts.when(
    //   error: (error, stackTrace) => const SizedBox(),
    //   loading: () => const _BuildColumn(child: _SkeletonLoader()),
    //   data: (broadcasts) {
    //     Logger().f(broadcasts);

    //     return Container();
    //     // return _BuildColumn(
    //     //   child: BroadcastListWidget(
    //     //     itemBuilder: (context, i) => _LiveCard(broadcast: broadcasts[i]!),
    //     //     itemCount: broadcasts.length,
    //     //   ),
    //     // );
    //   },
    // );

    return BlocBuilder<LiveBroadcastsBloc, LiveBroadcastsState>(
      bloc: context.read<LiveBroadcastsBloc>(),
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        loading: () => const _BuildColumn(child: _SkeletonLoader()),
        success: (broadcasts) => _BuildColumn(
          child: BroadcastListWidget(
            itemBuilder: (context, i) => _LiveCard(broadcast: broadcasts[i]!),
            itemCount: broadcasts.length,
          ),
        ),
      ),
    );
  }
}

/*
class NowLive extends StatelessWidget {
  const NowLive({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocketBloc, SocketState>(
      bloc: context.read<SocketBloc>()
        ,
      builder: (context, state) {
        if (state.loading) return const _BuildColumn(child: _SkeletonLoader());
      
        final broadcasts = state.liveBroadcasts;
        if (broadcasts.isEmpty) return const SizedBox();

        return _BuildColumn(
          child: BroadcastListWidget(
            itemBuilder: (context, i) => _LiveCard(broadcast: broadcasts[i]!),
            itemCount: state.liveBroadcasts.length,
          ),
        );
      },
    );
  }
}
*/
class _BuildColumn extends StatelessWidget {
  final Widget child;
  const _BuildColumn({required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MCore.xxxLarge.verticalSpace,
        MHeader(title: 'Now Live', actionTitle: 'See all', action: () {}),
        24.verticalSpace,
        LimitedBox(maxHeight: 184.h, child: child),
      ],
    );
  }
}

class _LiveCard extends StatelessWidget {
  final Broadcast broadcast;
  const _LiveCard({required this.broadcast});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LiveParticipantsCubit>();

    return BlocBuilder<LiveParticipantsCubit, LiveParticipantsState>(
      bloc: bloc..fetch(broadcast.id),
      buildWhen: (p, c) => p.participants != c.participants,
      builder: (context, state) => MCard.live(
        title: broadcast.title.get()!,
        host: broadcast.creator!.fullName,
        imageUrl: broadcast.imageUrl,
        liveCount: state.participants.length,
        onTap: () => context.showModal(
          isScrollControlled: true,
          useRootNavigator: true,
          StreamModal(broadcast: broadcast),
        ),
      ),
    );
  }
}

class _SkeletonLoader extends StatelessWidget {
  const _SkeletonLoader();

  @override
  Widget build(BuildContext context) {
    return BroadcastListWidget(
      itemCount: 5,
      itemBuilder: (context, i) => MCard.live(loading: true),
    );
  }
}
