import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NoteCardOptionsModal extends StatelessWidget {
  const NoteCardOptionsModal({
    required this.note,
    this.folderId ,
    super.key,
  });
  final Note note;
  final ID? folderId;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);

    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (folderId != null) ...[
            MModalListTile(
              leading: const Icon(MIcons.file_02),
              title: 'Move Note',
              onTap: _moveNote,
            ),
            Spaces.verticalSmall,
          ],
          if (note.folder != null)
            MModalListTile(
              leading: const Icon(MIcons.x_close),
              title: 'Remove from Folder',
              onTap: _removeFromFolder,
            )
          else
            MModalListTile(
              leading: const Icon(MIcons.plus),
              title: 'Add to Folder',
              onTap: _addToFolder,
            ),
          Spaces.verticalSmall,
          const MModalListTile(
            leading: Icon(MIcons.share),
            title: 'Share',
          ),
          Spaces.verticalSmall,
          const MModalListTile(
            leading: Icon(MIcons.link_02),
            title: 'Copy Link',
          ),
          Spaces.verticalSmall,
          MModalListTile(
            leading: Icon(MIcons.trash, color: colors.error),
            title: 'Delete',
            titleColor: colors.error,
            onTap: _deleteNote,
          ),
          Spaces.verticalSmall,
        ],
      ),
    );
  }

  Future<void> _moveNote() async {
    final result = await router.push(
      Routes.moveNoteToFolderModal,
      extra: {'note': note, 'folderId': folderId},
    );
    if (result == true) return router.pop(result);
  }

  Future<void> _addToFolder() async {
    final result = await router.push(Routes.addNoteToFolderModal, extra: note);
    if (result == true) return router.pop(result);
  }

  Future<void> _deleteNote() async {
    final result = await router.push(Routes.deleteNoteDialog, extra: note);
    if (result == true) router.pop(result);
  }

  Future<void> _removeFromFolder() async {
    final r = await router.push(Routes.remoteNoteFromFolderDialog, extra: note);
    if (r == true) return router.pop(r);
  }
}
