import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/dependency_injector/injector.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../../services/meno/meno_bloc.dart';
import '../../../../../services/socket/event_names.dart';
import '../../../../../services/socket/socket_service.dart';
import '../../../../../shared/widgets/empty_list_widget.dart';
import '../../../application/live_broadcasts/live_broadcasts_bloc.dart';
import '../../../domain/domain.dart';
import '../../widgets/broadcast_list_widget.dart';

class NowLive extends StatelessWidget {
  const NowLive({super.key});

  @override
  Widget build(BuildContext context) {
    final liveBroadcastsBloc = context.read<LiveBroadcastsBloc>();

    return BlocListener<MenoBloc, MenoState>(
      listener: (context, state) {
        state.whenOrNull(
          endedBroadcast: () => liveBroadcastsBloc.add(
            const LiveBroadcastsEvent.getLiveBroadcasts(),
          ),
        );
      },
      child: BlocBuilder<LiveBroadcastsBloc, LiveBroadcastsState>(
        bloc: liveBroadcastsBloc,
        builder: (context, state) => state.maybeWhen(
          orElse: () => const _BuildColumn(child: EmptyListWidget()),
          loading: () => const _BuildColumn(child: _SkeletonLoader()),
          success: (broadcasts) => _BuildColumn(
            showSeeAllButton: true,
            child: BroadcastListWidget(
              itemBuilder: (context, i) => _LiveCard(broadcast: broadcasts[i]!),
              itemCount: broadcasts.length,
            ),
          ),
        ),
      ),
    );
  }
}

class _LiveCard extends HookWidget {
  final Broadcast broadcast;
  const _LiveCard({required this.broadcast});

  @override
  Widget build(BuildContext context) {
    final socketService = di<SocketService>();
    final number = useState(0);

    useEffect(() {
      socketService.socket.emitWithAck(
        sEGetNumberOfBroadcastListeners,
        {'broadcastId': broadcast.id},
        ack: (data) => number.value = jsonDecode(jsonEncode(data))['data'],
      );
      return null;
    }, [number]);

    return MCard.live(
      title: broadcast.title.getOr(),
      host: broadcast.creator!.fullName,
      imageUrl: broadcast.imageUrl,
      liveCount: number.value,
      onTap: () => context.showJoinLiveBroadcastModal(broadcast),
    );
  }
}

class _BuildColumn extends StatelessWidget {
  final Widget child;
  final bool showSeeAllButton;
  const _BuildColumn({required this.child, this.showSeeAllButton = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MCore.xxxLarge.verticalSpace,
        MHeader(
          title: 'Now Live',
          action: InkWell(
            onTap:showSeeAllButton? () {} : null,
            child: MText(
              'See all',
              color: MColorScheme.of(context)!.onBackgroundVariant,
            ),
          ),
        ),
        24.verticalSpace,
        LimitedBox(maxHeight: 184.h, child: child),
      ],
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
