import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class VerseWidget extends StatelessWidget {
  const VerseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(MCore.small),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MCore.circle),
            color: colorScheme.primaryContainer,
          ),
          child: const MText('Rom 1:1', style: MTextStyle.microMedium),
        ),
        MCore.micro.verticalSpace,
        const MText(
          'This letter is from Paul, a slave of Christ Jesus, chosen by God to be an apostle and sent out to preach his Good News.',
          style: MTextStyle.bodyRegular,
        ),
        MCore.medium.verticalSpace,
      ],
    );
  }
}
