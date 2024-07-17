import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/dependency_injector/injector.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/services/services.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

class NowLive extends StatelessWidget {
  const NowLive({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveBroadcastsBloc, LiveBroadcastsState>(
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
    );
  }
}

class _LiveCard extends HookWidget {
  final Broadcast broadcast;
  const _LiveCard({required this.broadcast});

  @override
  Widget build(BuildContext context) {
    final socketService = di<SocketService>();
    final subscription = useStream(socketService.stateStream);

    useEffect(() {
      final id = broadcast.id.getOr();
      socketService.emit(SocketEvent.getNumberOfBroadcastListeners(id));
      return null;
    }, [subscription]);

    return MCard.live(
      title: broadcast.title.getOr(),
      host: broadcast.creator!.fullName,
      imageUrl: broadcast.imageUrl,
      liveCount: subscription.data?.maybeWhen(
        getNumberOfBroadcastListeners: (data, error) => data,
        orElse: () => 1,
      ),
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
            onTap: showSeeAllButton ? () {} : null,
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
