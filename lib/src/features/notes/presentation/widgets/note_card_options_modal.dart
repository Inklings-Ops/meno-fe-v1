import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NoteCardOptionsModal extends StatelessWidget {
  const NoteCardOptionsModal({required this.note, super.key});
  final Note note;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;

    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (note.folder != null)
            MModalListTile(
              leading: const Icon(MIcons.plus),
              title: 'Remove from Folder',
              onTap: () => context.showRemoveNoteFromFolderDialog(note),
            )
          else
            MModalListTile(
              leading: const Icon(MIcons.plus),
              title: 'Add to Folder',
              onTap: () => context.showModal<void>(
                AddToFolderModal(note: note),
                useRootNavigator: true,
                isScrollControlled: true,
              ),
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
            onTap: () => context.showDeleteNoteDialog(note),
          ),
          Spaces.verticalSmall,
        ],
      ),
    );
  }
}
