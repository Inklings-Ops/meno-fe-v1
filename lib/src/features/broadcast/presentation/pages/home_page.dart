import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../router/router.dart';
import '../../../auth/application/application.dart';
import '../../application/broadcast/broadcast_notifier.dart';
import '../../domain/domain.dart';

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const LiveActivityCard(),
            const MText("Home"),
            20.verticalSpace,
            MSecondaryButton.icon(
              label: "Logout",
              icon: const Icon(MIcons.log_out),
              loading: ref.watch(authProvider).loading,
              onPressed: () {
                context.router.pushAndPopUntil(
                  LoginRoute(isPasswordOnly: true),
                  predicate: (route) => false,
                );
                ref.read(authProvider.notifier).partialLogout();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LiveActivityCard extends ConsumerWidget {
  const LiveActivityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = MColorScheme.of(context)!;

    final BroadcastState broadcastState = ref.watch(broadcastNotifierProvider);
    final Broadcast broadcast = broadcastState.broadcast;

    return switch (broadcastState.status) {
      Status.offAir => const SizedBox.shrink(),
      Status.reconnecting => const SizedBox(),
      Status.live => InkWell(
          onTap: () => context.router.navigate(const BroadcastRoute()),
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const MBadge.small(),
                            MSize.horizontalSpaceMicro,
                            MText(
                              "Now Live",
                              style: MTextStyle.microMedium,
                              color: colorScheme.error,
                            ),
                          ],
                        ),
                        2.verticalSpace,
                        Container(
                          height: 24,
                          alignment: Alignment.centerLeft,
                          child: MText(
                            broadcast.title.get()!,
                            style: MTextStyle.captionMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        MText(
                          broadcast.creator.fullName,
                          style: MTextStyle.captionRegular,
                          color: colorScheme.onDisabled,
                        ),
                      ],
                    ),
                  ),
                  MSize.horizontalSpaceMedium,
                  LimitedBox(
                    maxHeight: 32,
                    maxWidth: 79,
                    child: MDangerButton(
                      label: "End",
                      onPressed: ref
                          .read(broadcastNotifierProvider.notifier)
                          .endPressed,
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    };
  }
}
