import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/router/router.dart';

class BroadcastEndedModal extends HookWidget {
  const BroadcastEndedModal({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = useState(false);
    return PopScope(
      canPop: canPop.value,
      onPopInvoked: (_) {
        context.read<BroadcastBloc>().dispose();
        context.read<TimerCubit>().dispose();
        context.go(Routes.home);
        canPop.value = true;
      },
      child: MModal(
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: MCore.large).r,
              child: const MText(
                'Your live broadcast is complete! Great job.',
                style: MTextStyle.heading2Bold,
                textAlign: TextAlign.center,
              ),
            ),
            24.verticalSpace,
            const BroadcastArtworkWidget(),
            MCore.large.verticalSpace,
            const BroadcastTimer(
              showTimeAgo: false,
              textStyle: MTextStyle.heading2Bold,
            ),
            24.verticalSpace,
            // TODO: implement avatars of listeners
            const SizedBox(height: 32),
            MCore.small.verticalSpace,
            BlocSelector<LiveParticipantsBloc, LiveParticipantsState, int>(
              selector: (state) => state.participants.length,
              builder: (context, numberOfParticipants) => MText(
                '$numberOfParticipants people tuned in!',
                style: MTextStyle.captionRegular,
                textAlign: TextAlign.center,
              ),
            ),
            40.verticalSpace,
            MPrimaryButton(label: 'Publish Broadcast', onPressed: () {}),
            MCore.large.verticalSpace,
            MSecondaryButton(
              label: 'Go to Profile',
              onPressed: () => context.go(Routes.profile),
            ),
          ],
        ),
      ),
    );
  }
}
