import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/_routing/_routing.dart';
import 'package:meno/features/notes/manager/notes_manager.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NewNoteButton extends WatchingWidget {
  const NewNoteButton._({required this.isAction, this.onTap});

  const NewNoteButton.outlined({void Function()? onTap})
    : this._(isAction: false, onTap: onTap);

  const NewNoteButton.action({void Function()? onTap})
    : this._(isAction: true, onTap: onTap);

  final void Function()? onTap;
  final bool isAction;

  @override
  Widget build(BuildContext context) {
    final totalCount = watchValue((NotesManager m) => m.totalNotesCount);

    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    if (isAction) {
      if (totalCount < 1) return const SizedBox.shrink();

      return InkWell(
        onTap: onTap ?? () => context.push(R.noteEditor()),
        child: Row(
          children: [
            Icon(MIcons.plus, size: 22, color: colors.primary),
            Spaces.horizontalMicro,
            MText(
              'Add New Note',
              style: textTheme.captionMedium,
              color: colors.primary,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: 139,
      height: 32,
      child: MSecondaryButton.icon(
        label: 'Add New Note',
        icon: const Icon(MIcons.plus),
        style: OutlinedButton.styleFrom(
          textStyle: textTheme.microMedium,
          foregroundColor: colors.onBackground,
          iconColor: colors.onBackground,
          shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
          side: BorderSide(color: colors.outlineVariant3, width: 1.50),
        ),
        onPressed: onTap ?? () => context.push(R.noteEditor()),
      ),
    );
  }
}
