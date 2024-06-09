import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart' hide Assets;
import 'package:meno_fe_v1/gen/assets.gen.dart';
import 'package:meno_fe_v1/src/shared/extensions/extensions.dart';

import 'create_folder_modal.dart';

class EmptyFolderListWidget extends StatelessWidget {
  const EmptyFolderListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 266.w,
      height: 224.h,
      child: Column(
        children: [
          Assets.images.folder.image(height: 120.h, width: 160.w),
          const MText(
            'Welcome! Organize your notes better through folders.',
            style: MTextStyle.bodyRegular,
            textAlign: TextAlign.center,
          ),
          24.verticalSpace,
          const _CreateNewFolderButton(),
        ],
      ),
    );
  }
}

class _CreateNewFolderButton extends StatelessWidget {
  const _CreateNewFolderButton();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return SizedBox(
      width: 160.w,
      height: 32.h,
      child: MSecondaryButton.icon(
        label: 'Create New Folder',
        icon: const Icon(MIcons.plus),
        style: OutlinedButton.styleFrom(
          textStyle: MTextStyle.microMedium,
          foregroundColor: colors.onBackground,
          iconColor: colors.onBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8).r,
          ),
          side: BorderSide(
            color: colors.outlineVariant3!,
            width: 1.50.r,
          ),
        ),
        onPressed: () => context.showModal(
          const CreateFolderModal(),
          useRootNavigator: true,
          isScrollControlled: true,
        ),
      ),
    );
  }
}
