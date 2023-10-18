import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcasterInfoModal extends StatelessWidget {
  const BroadcasterInfoModal({super.key});

  @override
  Widget build(BuildContext context) {
    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MAvatar(radius: 48, isArtwork: true),
          MSize.verticalSpaceSmall,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: MText(
              "Deeper UK: Who is Jesus, Who are you? (Grand Finale)",
              style: MTextStyle.subheadingBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          MSize.verticalSpaceMicro,
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MText(
                  "Celebration Church Int’l",
                  style: MTextStyle.captionRegular,
                ),
                MSize.horizontalSpaceSmall,
                MBadge.live(),
              ],
            ),
          ),
          24.verticalSpace,
          ListTile(
            leading: const Icon(MIcons.share, size: 20),
            title: const MText("Share"),
            titleTextStyle: MTextStyle.bodyRegular,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: MCore.medium,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(MIcons.link_02, size: 20),
            title: const MText("Copy Link"),
            titleTextStyle: MTextStyle.bodyRegular,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: MCore.medium,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
