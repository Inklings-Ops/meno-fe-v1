import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/notes/application/folder_list/folder_list_bloc.dart';

class DeleteFolderAlertDialog extends StatelessWidget {
  const DeleteFolderAlertDialog({
    super.key,
    required this.onDelete,
    this.onCancel,
  });

  final VoidCallback onDelete;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;
    final bloc = context.watch<FolderListBloc>();

    return AlertDialog(
      title: const MText('Delete Folder?', style: MTextStyle.heading2Regular),
      contentPadding: const EdgeInsets.all(24).r,
      content: const MText(
        'Do want to delete this folder?',
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
          width: 88.w,
          child: bloc.state == const FolderListState.loading()
              ? const MLoadingIndicator.four()
              : MDangerButton(
                  label: 'Delete',
                  onPressed: onDelete,
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                  ),
                ),
        ),
      ],
    );
  }
}
