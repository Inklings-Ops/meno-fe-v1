import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';

class CreateBroadcastListItem extends StatelessWidget {
  final String leadingText;
  final String subtitleText;
  final Widget? trailing;

  const CreateBroadcastListItem({
    super.key,
    required this.leadingText,
    required this.subtitleText,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12).r,
          decoration: BoxDecoration(
            color: theme.disabledColor,
            borderRadius: BorderRadius.all(const Radius.circular(8).r),
          ),
          child: SizedBox(
            height: 24.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MText(
                    leadingText,
                    style: MTextStyle.captionMedium,
                  ),
                ),
                MCore.large.horizontalSpace,
                trailing ?? const SizedBox(),
              ],
            ),
          ),
        ),
        6.verticalSpace,
        SizedBox(
          height: 18.h,
          child: MText(subtitleText, style: MTextStyle.captionRegular),
        ),
      ],
    );
  }
}
