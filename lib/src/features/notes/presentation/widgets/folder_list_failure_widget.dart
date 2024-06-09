import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/notes/application/folder_list/folder_list_bloc.dart';

class FolderListFailureWidget extends StatelessWidget {
  const FolderListFailureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return Column(
      children: [
        72.verticalSpace,
        const MText(
          'An error occurred while retrieving the folders. Please, reload to try again?',
          style: MTextStyle.bodyRegular,
          textAlign: TextAlign.center,
        ),
        24.verticalSpace,
        SizedBox(
          height: 32.h,
          child: MSecondaryButton.icon(
            label: 'Reload',
            icon: const Icon(Icons.refresh),
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
            onPressed: () => context
                .read<FolderListBloc>()
                .add(const FolderListEvent.getAllFolders()),
          ),
        )
      ],
    );
  }
}
