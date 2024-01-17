import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../domain/domain.dart';

class ParticipantItem extends StatelessWidget {
  final Participant? participant;
  final VoidCallback? onTap;
  final bool isCohost;
  final bool isForAddCohost;

  const ParticipantItem({
    super.key,
    this.participant,
    this.onTap,
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
                color: hasUser ? null : MColor.grey50,
              ),
            ),
            if (isCohost) ...[
              MCore.micro.verticalSpace,
              const MText('Co-host', style: MTextStyle.nanoRegular),
            ],
          ],
        ),
      ),
    );
  }
}
