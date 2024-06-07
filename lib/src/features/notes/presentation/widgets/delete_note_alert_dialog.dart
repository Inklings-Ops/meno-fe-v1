import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

class DeleteNoteAlertDialog extends StatelessWidget {
  const DeleteNoteAlertDialog({
    super.key,
    required this.onDelete,
    this.onCancel,
  });

  final VoidCallback onDelete;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return AlertDialog(
      title: const MText('Delete Note?', style: MTextStyle.heading2Regular),
      contentPadding: const EdgeInsets.all(24).r,
      content: const MText(
        'Do want to delete this note?',
        style: MTextStyle.captionRegular,
      ),
      actions: [
        SizedBox.fromSize(
          size: Size(85.w, 40.h),
          child: MTextButton(
            label: 'Cancel',
            onPressed: onCancel ?? () => context.pop(false),
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
            label: 'Delete',
            onPressed: onDelete,
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
