import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/core/broadcast/meno_event_provider.dart';

import '../../../../../services/socket/socket_service.dart';
import '../../../application/broadcast/broadcast_notifier.dart';
import '../../../application/broadcast_list/broadcast_list_provider.dart';
import 'home_app_bar.dart';
import 'live_activity_card.dart';
import 'live_for_you.dart';
import 'now_live.dart';
import 'recently_live.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> onRefresh() {
      ref.refresh(socketServiceProvider.notifier).getLiveBroadcasts();
      return Future.wait([
        ref.refresh(recentBroadcastsProvider(limit: 8).future),
      ]);
    }

    final status = ref.watch(broadcastNotifierProvider.select((v) => v.status));

    final isStreaming = useState(false);

    ref.listen(eventProvider, (previous, next) {
      next.event.whenOrNull(
        isStreaming: () => isStreaming.value = true,
        leaveBroadcast: () => isStreaming.value = false,
        endedBroadcast: (_) => isStreaming.value = false,
      );
    });

    return MScaffold(
      appBar: const HomeAppBar(),
      padding: EdgeInsets.zero,
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (isStreaming.value) ...[
                24.verticalSpace,
                const LiveActivityCard(),
                MCore.xxLarge.verticalSpace,
              ] else
                24.verticalSpace,
              const LiveForYou(),
              const NowLive(),
              const RecentlyLive(),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
