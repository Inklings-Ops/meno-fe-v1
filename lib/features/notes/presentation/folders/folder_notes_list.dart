import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:meno/features/notes/applications/applications.dart';
import 'package:meno/features/notes/domain/domain.dart';
import 'package:meno/features/notes/presentation/presentation.dart';
import 'package:meno_design_system/meno_design_system.dart';

class FolderNotesList extends WatchingWidget {
  const FolderNotesList({super.key});

  @override
  Widget build(BuildContext context) {
    final folder = watchValue((FolderManager m) => m.folder);
    final notes = folder.notes;

    if (notes.isEmpty) return _EmptyFolderPlaceholder(folder: folder);

    return NotesList(
      notes: notes,
      onNoteTap: (note) => _onNoteTap(context, note),
      // onOptionTap: (note) => _onOptionsTap(note, state.folder),
    );
  }

  Future<void> _onNoteTap(BuildContext context, Note note) async {
    // final bloc = context.read<NotesBloc>();
    // final newNote = await router.push<Note?>(Routes.noteEditor, extra: note);
    // if (newNote != null) return bloc.add(NotesNoteReceived(newNote));
  }

  Future<void> _onOptionsTap(Note note, NoteFolder folder) async {
    // final noteWithFolder = note.copyWith(folder: folder);
    // await router.push(
    //   Routes.noteCardOptionsModal,
    //   extra: {'note': noteWithFolder, 'folderId': folder.id},
    // );
  }
}

class _EmptyFolderPlaceholder extends StatelessWidget {
  const _EmptyFolderPlaceholder({required this.folder});

  final NoteFolder folder;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return Container(
      width: 266,
      height: 224,
      margin: const EdgeInsets.only(top: 64),
      child: Column(
        children: [
          Assets.images.newFile.image(height: 120, width: 160),
          MText(
            'Let’s add some notes to this folder',
            style: textTheme.bodyRegular,
            textAlign: TextAlign.center,
          ),
          Spaces.verticalXLarge,
          SizedBox(
            width: 155,
            height: 32,
            child: MSecondaryButton.icon(
              label: 'Add to this Folder',
              icon: const Icon(MIcons.plus),
              style: OutlinedButton.styleFrom(
                textStyle: textTheme.microMedium,
                foregroundColor: colors.onBackground,
                iconColor: colors.onBackground,
                shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
                side: BorderSide(color: colors.outlineVariant3, width: 1.50),
              ),
              onPressed: () =>
                  AddNotesToFolderModal.show(context, folder: folder),
            ),
          ),
        ],
      ),
    );
  }
}
