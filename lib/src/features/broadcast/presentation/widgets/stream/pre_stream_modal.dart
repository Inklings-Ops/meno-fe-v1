import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/features/chat/chat.dart';
import 'package:meno_fe_v1/src/router/router.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

class PreStreamModal extends StatelessWidget {
  const PreStreamModal({super.key, required this.broadcast});
  final Broadcast broadcast;

  @override
  Widget build(BuildContext context) {
    return BlocListener<StreamBloc, StreamState>(
      listener: (context, state) {
        state.whenOrNull(
          failure: (exception) => context.showBroadcastError(exception),
          joinFailed: (error) => context.showErrorSnackBar(error.toString()),
          joinSuccess: (broadcast) {
            context.pop();
            Logger().w('[FROM STREAM PAGE TIMER] => //${broadcast.startTime}');
            context.read<LiveParticipantsBloc>().initialize(broadcast);
            context.read<ChatBloc>().initialize(broadcast);
            context.read<TimerCubit>()
              ..set(broadcast.startTime)
              ..start();
            context.push(Routes.stream, extra: broadcast);
          },
        );
      },
      child: MModal(
        title: 'Stream',
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.22,
          minChildSize: 0.22,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Scaffold(
            body: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TopSection(broadcast: broadcast),
                  24.verticalSpace,
                  PreStreamDescriptionSection(broadcast: broadcast),
                  24.verticalSpace,
                  MHeader(
                    title: 'Recent Broadcasts',
                    showSideBorder: false,
                    padding: EdgeInsets.zero,
                    action: InkWell(
                      onTap: () {},
                      child: MText(
                        'See all',
                        color: MColorScheme.of(context)!.onBackgroundVariant,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopSection extends StatelessWidget {
  final Broadcast broadcast;

  const _TopSection({required this.broadcast});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 142.h,
      child: Row(
        children: [
          PreStreamArtwork(imageUrl: broadcast.imageUrl),
          MCore.large.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MText(
                  broadcast.title.getOr(),
                  style: MTextStyle.subheadingMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                6.verticalSpace,
                const MBadge.live(),
                6.verticalSpace,
                MText(
                  broadcast.creator == null
                      ? broadcast.fullName!
                      : broadcast.creator!.fullName,
                  style: MTextStyle.captionRegular,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                MCore.medium.verticalSpace,
                PreStreamActionButtons(broadcast: broadcast),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
