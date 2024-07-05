import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart' hide Assets;
import 'package:meno_fe_v1/gen/assets.gen.dart';
import 'package:meno_fe_v1/src/router/router.dart';

class EmptyNoteListWidget extends StatelessWidget {
  const EmptyNoteListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 266.w,
      height: 224.h,
      child: Column(
        children: [
          Assets.images.newFile.image(height: 120.h, width: 160.w),
          const MText(
            'Welcome! Start writing down everything you take in.',
            style: MTextStyle.bodyRegular,
            textAlign: TextAlign.center,
          ),
          24.verticalSpace,
          const AddNewNoteButton(),
        ],
      ),
    );
  }
}

class AddNewNoteButton extends StatelessWidget {
  const AddNewNoteButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return SizedBox(
      width: 139.w,
      height: 32.h,
      child: MSecondaryButton.icon(
        label: 'Add New Note',
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
        onPressed: () => context.push(Routes.noteEditor),
      ),
    );
  }
}
