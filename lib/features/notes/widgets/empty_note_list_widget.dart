import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class EmptyNoteListWidget extends StatelessWidget {
  const EmptyNoteListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = MTextTheme.of(context);
    return Center(
      child: SizedBox(
        width: 266,
        child: Column(
          children: [
            Assets.images.newFile.image(height: 120, width: 160),
            MText(
              'Welcome! Start writing down everything you take in.',
              style: textTheme.bodyRegular,
              textAlign: .center,
            ),
            Spaces.verticalXLarge,
            const _AddNewNoteButton(),
          ],
        ),
      ),
    );
  }
}

class _AddNewNoteButton extends StatelessWidget {
  const _AddNewNoteButton();

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
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
        onPressed: () async {
          // TODO(gettoknowdavid): handle _AddNewNoteButton on press
          // final bloc = context.read<NotesBloc>();
          // final newNote = await router.push<Note?>(Routes.noteEditor);
          // if (newNote != null) return bloc.add(NotesNoteReceived(newNote));
        },
      ),
    );
  }
}
