import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:go_router/go_router.dart';
import 'package:meno/features/notes/applications/applications.dart';
import 'package:meno/features/notes/domain/entities/note.dart';
import 'package:meno/features/notes/presentation/folders/move_notes_to_folder_modal.dart';
import 'package:meno/shared/domain/domain.dart';
import 'package:meno/shared/presentation/widgets/delete_alert_dialog.dart';
import 'package:meno_design_system/meno_design_system.dart';

class NoteCardOptionsModal extends WatchingWidget {
  const NoteCardOptionsModal({required this.note, this.folderId, super.key});

  final Note note;
  final Id? folderId;

  static Future<dynamic> show(BuildContext context, Note note, [Id? folderId]) {
    return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) => NoteCardOptionsModal(note: note, folderId: folderId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    registerHandler(
      select: (NotesManager m) => m.deleteNote,
      handler: (context, newValue, cancel) {
        if (newValue ?? false) context.pop();
      },
    );

    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (folderId != null) ...[
            // Show this option only when a [folderId] is passed to modal when
            // it is called from the Folder Page
            MModalListTile(
              leading: const Icon(MIcons.file_02),
              title: 'Move Note',
              onTap: () => MoveNotesToFolderModal.show(context, note),
            ),
            Spaces.verticalSmall,
          ],

          if (note.folder != null)
            // Show if the note is in a folder, regardless of where the modal
            // is called from
            MModalListTile(
              leading: const Icon(MIcons.x_close),
              title: 'Remove from Folder',
              onTap: _removeFromFolder,
            )
          else
            // Show if the note is not in a folder, regardless of where the
            // modal is called from
            MModalListTile(
              leading: const Icon(MIcons.plus),
              title: 'Add to Folder',
              onTap: _addToFolder,
            ),

          if (folderId == null || note.folder == null) ...[
            // Show if a [folderId] is passed or the note is not in a folder
            Spaces.verticalSmall,
            MModalListTile(
              leading: const Icon(MIcons.share),
              title: 'Share',
              onTap: () {},
            ),
            Spaces.verticalSmall,
            MModalListTile(
              leading: const Icon(MIcons.link_02),
              title: 'Copy Link',
              onTap: () {},
            ),
          ],

          // Always show the rest
          Spaces.verticalSmall,
          MModalListTile(
            leading: Icon(MIcons.trash, color: colors.error),
            title: 'Delete',
            titleColor: colors.error,
            onTap: () => _deleteNote(context),
          ),
          Spaces.verticalSmall,
        ],
      ),
    );
  }

  Future<void> _moveNote() async {
    // final result = await router.push(
    //   Routes.moveNoteToFolderModal,
    //   extra: {'note': note, 'folderId': folderId},
    // );
    // if (result == true) return router.pop(result);
  }

  Future<void> _addToFolder() async {
    // final result=await router.push(Routes.addNoteToFolderModal, extra: note);
    // if (result == true) return router.pop(result);
  }

  Future<void> _removeFromFolder() async {
    //final r=await router.push(Routes.remoteNoteFromFolderDialog, extra: note);
    // if (r == true) return router.pop(r);
  }

  Future<void> _deleteNote(BuildContext context) async {
    final result = await DeleteAlertDialog.show(
      context,
      title: 'Delete Note?',
      description: 'Do want to delete this note?',
    );

    if (result ?? false) {
      di<NotesManager>().deleteNote.run(note.id);
      if (context.mounted) context.pop();
    }
  }
}
