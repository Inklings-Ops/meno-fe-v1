import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ListenerInfoModal extends StatelessWidget {
  const ListenerInfoModal({super.key});

  @override
  Widget build(BuildContext context) {
    const bool isCohost = true;

    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MAvatar(radius: 36),
          MSize.verticalSpaceLarge,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                MText(
                  "Bayo Daini",
                  style: MTextStyle.heading3Medium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isCohost) ...[
                  MSize.horizontalSpaceSmall,
                  MBadge.cohost(),
                ]
              ],
            ),
          ),
          MSize.verticalSpaceMicro,
          const MText(
            "Teacher | Software Developer | Christian Social Innovator",
            style: MTextStyle.subheadingRegular,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          MSize.verticalSpaceLarge,
          MPrimaryButton.icon(
            label: "Subscribed",
            icon: const Icon(MIcons.user_check),
            onPressed: () {},
          ),
          MSize.verticalSpaceSmall,
          MTextButton(
            label: "Remove as Co-host",
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
