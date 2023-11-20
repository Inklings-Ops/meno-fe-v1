import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

import '../../domain/domain.dart';

class ParticipantInfoModal extends StatelessWidget {
  final Participant participant;
  const ParticipantInfoModal({super.key, required this.participant});

  @override
  Widget build(BuildContext context) {
    const bool isCohost = true;

    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MAvatar(radius: 36.r, url: participant.imageUrl),
          MCore.large.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0).r,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                MText(
                  participant.fullName,
                  style: MTextStyle.heading3Medium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isCohost) ...[
                  MCore.small.horizontalSpace,
                  const MBadge.cohost(),
                ]
              ],
            ),
          ),
          MCore.micro.verticalSpace,
          const MText(
            "Teacher | Software Developer | Christian Social Innovator",
            style: MTextStyle.subheadingRegular,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          MCore.large.verticalSpace,
          MPrimaryButton.icon(
            label: "Subscribed",
            icon: const Icon(MIcons.user_check),
            onPressed: () {},
          ),
          MCore.small.verticalSpace,
          MTextButton(
            label: "Remove as Co-host",
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
