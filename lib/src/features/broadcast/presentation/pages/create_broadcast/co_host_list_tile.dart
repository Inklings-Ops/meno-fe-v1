import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class CohostListTile extends StatelessWidget {
  const CohostListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: Row(
        children: [
          MAvatar(radius: 24.r),
          MCore.small.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const MText(
                  'Celebration Church International',
                  style: MTextStyle.captionMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                3.verticalSpace,
                const MText('30K Subscribers', style: MTextStyle.microRegular),
              ],
            ),
          ),
          MCore.large.horizontalSpace,
          SizedBox(
            height: 32.h,
            child: MSecondaryButton(
              label: 'Add as Co-host',
              style: OutlinedButton.styleFrom(
                textStyle: MTextStyle.microMedium,
                padding: const EdgeInsets.symmetric(horizontal: MCore.large).r,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8).r,
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
