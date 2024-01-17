import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../../services/socket/socket_service.dart';
import '../../../domain/domain.dart';
import '../../widgets/broadcast_list_widget.dart';
import '../stream/stream_modal.dart';

class NowLive extends ConsumerWidget {
  const NowLive({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcasts = ref.watch(socketServiceProvider.select(
      (value) => value.liveBroadcasts,
    ));

    final isLoading = ref.watch(
      socketServiceProvider.select((value) => value.loading),
    );

    if (isLoading) {
      return const _BuildColumn(child: _SkeletonLoader());
    }

    if (broadcasts.isNotEmpty) {
      return _BuildColumn(
        child: BroadcastListWidget(
          itemBuilder: (context, i) => _LiveCard(broadcast: broadcasts[i]!),
          itemCount: broadcasts.length,
        ),
      );
    }

    return const SizedBox();
  }
}

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

class _LiveCard extends HookConsumerWidget {
  final Broadcast broadcast;
  const _LiveCard({required this.broadcast});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final number = useState<int>(0);

    ref.listen(socketServiceProvider, (previous, next) {
      if (previous != next) {
        ref.read(getParticipantsProvider(broadcast.id)).whenOrNull(
              data: (data) => number.value = data.length,
            );
      }
    });

    return MCard.live(
      title: broadcast.title.get()!,
      host: broadcast.creator!.fullName,
      imageUrl: broadcast.imageUrl,
      liveCount: number.value,
      onTap: () => context.showModal(
        isScrollControlled: true,
        useRootNavigator: true,
        StreamModal(broadcast: broadcast),
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
