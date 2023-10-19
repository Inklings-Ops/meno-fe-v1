import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class CohostListTile extends StatelessWidget {
  const CohostListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          const MAvatar(radius: 24),
          MSize.horizontalSpaceSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const MText(
                  "Celebration Church International",
                  style: MTextStyle.captionMedium,
                ),
                3.verticalSpace,
                const MText(
                  "30K Subscribers",
                  style: MTextStyle.microRegular,
                ),
              ],
            ),
          ),
          MSize.horizontalSpaceLarge,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: MSecondaryButton(
              label: "Add as Co-host",
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
