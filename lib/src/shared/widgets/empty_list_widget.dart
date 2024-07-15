import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.liveForYou.image(height: 120.r, width: 120.r),
          MCore.medium.verticalSpace,
          MText(
            title ?? 'Nothing to show here',
            style: MTextStyle.captionMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
