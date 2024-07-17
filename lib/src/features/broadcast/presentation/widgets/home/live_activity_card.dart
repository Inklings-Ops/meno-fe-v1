import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/broadcast/broadcast.dart';
import 'package:meno_fe_v1/src/router/router.dart';
import 'package:meno_fe_v1/src/services/services.dart' hide StreamState;
import 'package:meno_fe_v1/src/shared/shared.dart';

class LiveActivityCard extends StatelessWidget {
  const LiveActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StreamBloc, StreamState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        joinSuccess: (broadcast) => BlocBuilder<MenoBloc, MenoState>(
          builder: (context, menoState) => menoState.maybeWhen(
            orElse: () => const SizedBox(),
            streaming: () => const ActivityCard(badgeTitle: 'Now Streaming'),
            reconnecting: () => const ActivityCard(badgeTitle: 'Reconnecting'),
          ),
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.badgeTitle});
  final String badgeTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: MCore.xxLarge).r,
      child: InkWell(
        onTap: () => context.push(Routes.stream),
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
                      _Badge(badgeTitle: badgeTitle),
                      2.verticalSpace,
                      const _StreamTitle(),
                      const _StreamCreatorName(),
                    ],
                  ),
                ),
                MCore.medium.horizontalSpace,
                const _LeaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.badgeTitle});
  final String badgeTitle;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return Row(
      children: [
        CircleAvatar(
          radius: 5.r,
          backgroundColor: colors.secondaryContainer,
          child: CircleAvatar(radius: 3.r, backgroundColor: colors.secondary),
        ),
        MCore.micro.horizontalSpace,
        MText(
          badgeTitle,
          style: MTextStyle.microMedium,
          color: MColorScheme.of(context)?.error,
        ),
      ],
    );
  }
}

class _LeaveButton extends StatelessWidget {
  const _LeaveButton();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<StreamBloc>();

    return BlocBuilder<StreamBloc, StreamState>(
      builder: (context, state) {
        void onLeave() {
          context.showLeaveBroadcastDialog().then((value) {
            if (value == true && state is StreamJoinSuccess) {
              bloc.add(StreamEvent.leave(state.broadcast.id));
              bloc.dispose();
              context.go(Routes.home);
            }
          });
        }

        return LimitedBox(
          maxHeight: 32.h,
          maxWidth: 79.w,
          child: MDangerButton(
            label: 'Leave',
            onPressed: onLeave,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8).r,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StreamTitle extends StatelessWidget {
  const _StreamTitle();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StreamBloc, StreamState, String?>(
      selector: (state) => state.whenOrNull(
        joinSuccess: (b) => b.title.getOr(),
      ),
      builder: (context, title) {
        if (title == null) return const SizedBox();
        return Container(
          height: 24.h,
          alignment: Alignment.centerLeft,
          child: MText(
            title,
            style: MTextStyle.captionMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}

class _StreamCreatorName extends StatelessWidget {
  const _StreamCreatorName();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<StreamBloc, StreamState, String?>(
      selector: (state) => state.whenOrNull(
        joinSuccess: (b) => b.creator?.fullName,
      ),
      builder: (context, fullName) {
        if (fullName == null) return const SizedBox();
        return MText(
          fullName,
          style: MTextStyle.captionRegular,
          color: MColorScheme.of(context)!.onBackgroundVariant,
        );
      },
    );
  }
}
