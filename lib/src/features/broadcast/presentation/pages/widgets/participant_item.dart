import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../../domain/domain.dart';

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
    final MColorScheme colorScheme = MColorScheme.of(context)!;

    final bool hasUser = participant != null;

    return InkWell(
      onTap: onTap,
      child: SizedBox.fromSize(
        size: const Size.fromWidth(76),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              fit: StackFit.loose,
              children: [
                MAvatar(
                  radius: 24,
                  url: participant?.imageUrl,
                  child: hasUser
                      ? null
                      : Icon(
                          MIcons.users_plus,
                          color: colorScheme.onBackground,
                          size: 16,
                        ),
                ),
                if (isForAddCohost)
                  Positioned(
                    left: 30,
                    top: 30,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: colorScheme.background!,
                        ),
                      ),
                      child: Icon(
                        MIcons.x_close,
                        size: 8,
                        color: colorScheme.onError,
                      ),
                    ),
                  ),
              ],
            ),
            MSize.verticalSpaceSmall,
            Flexible(
              child: MText(
                hasUser ? participant!.fullName : "Add Co-host",
                style: MTextStyle.microMedium,
                color: hasUser ? null : MColor.grey50,
              ),
            ),
            if (isCohost) ...[
              MSize.verticalSpaceMicro,
              const MText("Co-host", style: MTextStyle.nanoRegular),
            ],
          ],
        ),
      ),
    );
  }
}
