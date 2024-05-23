import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/bible/application/scripture_picker/scripture_picker_cubit.dart';

class ChapterWidget extends StatelessWidget {
  const ChapterWidget({super.key, required this.chapter});

  final int chapter;

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;
    final borderRadius = BorderRadius.circular(MCore.small).r;

    return InkWell(
      onTap: () {
        context.read<ScripturePickerCubit>().chapterChanged(chapter);
        Navigator.pop(context);
      },
      borderRadius: borderRadius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: colorScheme.outlineVariant1?.withOpacity(0.5),
        ),
        child: MText('$chapter'),
      ),
    );
  }
}
