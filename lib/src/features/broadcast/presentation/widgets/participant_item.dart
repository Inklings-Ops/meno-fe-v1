import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/shared/shared.dart';

import '../../domain/domain.dart';

class ParticipantItem extends StatelessWidget {
  final Participant? participant;
  final VoidCallback? onTap;
  final bool isCohost;
  final bool isForAddCohost;
  final bool isCreator;

  const ParticipantItem({
    super.key,
    this.participant,
    this.onTap,
    this.isCreator = false,
    this.isCohost = false,
    this.isForAddCohost = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    final hasUser = participant != null;

    return InkWell(
      onTap: onTap,
      child: SizedBox.fromSize(
        size: Size.fromWidth(76.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              fit: StackFit.loose,
              children: [
                MAvatar(
                  radius: 24.r,
                  url: participant?.imageUrl,
                  hasBorder: false,
                  child: hasUser
                      ? null
                      : Icon(
                          MIcons.users_plus,
                          color: colorScheme.onBackground,
                          size: 16.r,
                        ),
                ),
                if (isForAddCohost)
                  Positioned(
                    left: 30.r,
                    top: 30.r,
                    child: Container(
                      padding: const EdgeInsets.all(4).r,
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2.r,
                          color: colorScheme.background!,
                        ),
                      ),
                      child: Icon(
                        MIcons.x_close,
                        size: 8.r,
                        color: colorScheme.onError,
                      ),
                    ),
                  ),
              ],
            ),
            MCore.small.verticalSpace,
            Flexible(
              child: MText(
                hasUser ? participant!.fullName : 'Add Co-host',
                style: MTextStyle.microMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                color: hasUser ? null : MColor.grey50,
                textAlign: TextAlign.center,
              ),
            ),
            if (isCohost) ...[
              MCore.micro.verticalSpace,
              _CoHostTag(participantId: participant!.id),
            ],
            if (isCreator) ...[
              MCore.micro.verticalSpace,
              _HostTag(participantId: participant!.id),
            ],
          ],
        ),
      ),
    );
  }
}

class _HostTag extends StatelessWidget {
  const _HostTag({required this.participantId});
  final String participantId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        authenticated: (user, _) {
          if (participantId == user.id.getOr()) {
            return const _Tag(title: 'You');
          } else {
            return const _Tag(title: 'Host');
          }
        },
      ),
    );
  }
}

class _CoHostTag extends StatelessWidget {
  const _CoHostTag({required this.participantId});
  final String participantId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) => state.maybeWhen(
        orElse: () => const SizedBox(),
        authenticated: (user, _) {
          if (participantId == user.id.getOr()) {
            return const _Tag(title: 'You');
          } else {
            return const _Tag(title: 'Co-Host');
          }
        },
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return MText(title, style: MTextStyle.nanoRegular);
  }
}
