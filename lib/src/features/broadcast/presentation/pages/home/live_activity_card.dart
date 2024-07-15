import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import '../../../../../router/router.dart';
import '../../../../../services/meno/meno_bloc.dart';
import '../../../application/stream/stream_bloc.dart';
import '../../../domain/domain.dart';

class LiveActivityCard extends HookConsumerWidget {
  const LiveActivityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = context.read<StreamBloc>();

    void goToStreamPage() => context.push(Routes.stream);

    void onLeave() {
      context.showLeaveBroadcastDialog().then((value) {
        if (value == true) {
          bloc.add(const StreamEvent.leave());
          bloc.dispose();
          context.go(Routes.home);
        }
      });
    }

    return BlocBuilder<MenoBloc, MenoState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        streaming: (broadcast) => ActivityCard(
          broadcast: broadcast,
          onTap: goToStreamPage,
          badgeTitle: 'Now Streaming',
          actionTitle: 'Leave',
          action: onLeave,
        ),
        reconnecting: (broadcast) => ActivityCard(
          broadcast: broadcast,
          onTap: goToStreamPage,
          badgeTitle: 'Reconnecting',
          actionTitle: 'Leave',
          action: onLeave,
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.onTap,
    required this.badgeTitle,
    required this.broadcast,
    required this.actionTitle,
    required this.action,
  });

  final VoidCallback onTap;
  final String badgeTitle;
  final Broadcast broadcast;
  final String actionTitle;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: MCore.xxLarge).r,
      child: InkWell(
        onTap: onTap,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16).r,
          shape: const SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius.all(
              SmoothRadius(cornerRadius: 16, cornerSmoothing: 1),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14).r,
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
                          MCore.micro.horizontalSpace,
                          MText(
                            badgeTitle,
                            style: MTextStyle.microMedium,
                            color: MColorScheme.of(context)?.error,
                          ),
                        ],
                      ),
                      2.verticalSpace,
                      Container(
                        height: 24.h,
                        alignment: Alignment.centerLeft,
                        child: MText(
                          broadcast.title.getOr(),
                          style: MTextStyle.captionMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      MText(
                        broadcast.creator!.fullName,
                        style: MTextStyle.captionRegular,
                        color: colorScheme.onDisabled,
                      ),
                    ],
                  ),
                ),
                MCore.medium.horizontalSpace,
                LimitedBox(
                  maxHeight: 32.h,
                  maxWidth: 79.w,
                  child: MDangerButton(
                    label: actionTitle,
                    onPressed: action,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8).r,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
