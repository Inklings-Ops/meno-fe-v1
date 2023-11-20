import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../../../router/router.dart';
import '../../../../../services/socket/socket_service.dart';
import '../../../application/broadcast/broadcast_notifier.dart';
import '../../widgets/broadcast_artwork.dart';
import 'broadcast_timer.dart';

class BroadcastEndedModal extends ConsumerWidget {
  const BroadcastEndedModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participants = ref.watch(liveParticipantsProvider);
    final numberOfParticipants = participants.length.toString();

    return WillPopScope(
      onWillPop: () => Future.delayed(Duration.zero, () async {
        final router = GoRouter.of(context);
        await ref.read(broadcastNotifierProvider.notifier).dispose();
        router.go(Routes.home);
        return true;
      }),
      child: MModal(
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: MCore.large).r,
              child: const MText(
                "Your live broadcast is complete! Great job.",
                style: MTextStyle.heading2Bold,
                textAlign: TextAlign.center,
              ),
            ),
            24.verticalSpace,
            const BroadcastArtwork(),
            MCore.large.verticalSpace,
            const BroadcastTimer(
              showTimeAgo: false,
              textStyle: MTextStyle.heading2Bold,
            ),
            24.verticalSpace,
            const SizedBox(
              height: 32,
            ),
            MCore.small.verticalSpace,
            MText(
              "$numberOfParticipants people tuned in!",
              style: MTextStyle.captionRegular,
              textAlign: TextAlign.center,
            ),
            40.verticalSpace,
            MPrimaryButton(label: "Publish Broadcast", onPressed: () {}),
            MCore.large.verticalSpace,
            MSecondaryButton(
              label: "Go to Profile",
              onPressed: () => context.go(Routes.profile),
            ),
          ],
        ),
      ),
    );
  }
}
