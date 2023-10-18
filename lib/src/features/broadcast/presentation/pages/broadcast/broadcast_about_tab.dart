import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastAboutTab extends StatelessWidget {
  const BroadcastAboutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          24.verticalSpace,
          const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(MIcons.menu_03, size: 16),
              MSize.horizontalSpaceSmall,
              MText("About Broadcast", style: MTextStyle.subheadingMedium),
            ],
          ),
          MSize.verticalSpaceLarge,
          const MText(
            "By the revelation of Jesus Christ, we come to an awareness of who we are. The moment Peter correctly identified Jesus, he found his own identity (Matt. 16: 13-18). “There is an identity you’ll only find in God because He is the center of your life” In an exceedingly profound sermon titled ‘Who is Jesus, and Who Are We?’ The true identity of a believer goes beyond the ‘Christian’ tag—DOULOS; the distinction between Doulos and the modern definition of ‘Slave’; and the believer’s responsibility as one bought with a price.",
          ),
        ],
      ),
    );
  }
}
