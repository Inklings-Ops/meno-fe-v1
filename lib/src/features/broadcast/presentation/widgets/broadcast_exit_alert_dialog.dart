import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastExitAlertDialog extends StatelessWidget {
  final bool isBroadcasting;
  const BroadcastExitAlertDialog({super.key, this.isBroadcasting = true});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    String label = isBroadcasting ? "Stop Broadcasting?" : "Leave Broadcast?";
    String content = isBroadcasting
        ? "Do you want to end this live broadcast?"
        : "Do you want to leave this live broadcast?";

    return AlertDialog(
      title: MText(label, style: MTextStyle.heading2Regular),
      contentPadding: const EdgeInsets.all(24).r,
      content: MText(content, style: MTextStyle.captionRegular),
      actions: [
        SizedBox.fromSize(
          size: Size(85.w, 40.h),
          child: MTextButton(
            label: "Cancel",
            onPressed: () => context.pop(false),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onDisabled?.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(const Radius.circular(8).r),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 40.h,
          child: MDangerButton(
            label: isBroadcasting ? "Stop" : "Leave",
            onPressed: () => context.pop(true),
            style: TextButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(const Radius.circular(8).r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
