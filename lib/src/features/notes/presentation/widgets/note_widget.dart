import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_fe_v1/src/features/notes/application/note_list/notes_bloc.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({super.key, this.onTap, this.selected = false});

  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    final background = selected ? colors.primary : colors.inActiveContainer;
    final foreground = selected ? colors.onPrimary : colors.onInActiveContainer;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20).r,
      child: Container(
        height: 88.h,
        padding: const EdgeInsets.all(MCore.large).r,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(20).r,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MText(
              'Notes',
              style: MTextStyle.captionMedium,
              color: foreground,
            ),
            BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) => MText(
                state.notes.length.toString(),
                style: MTextStyle.heading2Medium,
                color: foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
