import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class NoteCardOptionsModal extends StatelessWidget {
  const NoteCardOptionsModal({required this.note, super.key});
  final Note note;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final folders = context.read<FoldersBloc>();

    return MModal(
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (note.folder != null)
            MModalListTile(
              leading: const Icon(MIcons.plus),
              title: 'Remove from Folder',
              onTap: () async {
                final result = await router.push(
                  Routes.remoteNoteFromFolderDialog,
                  extra: note,
                );
                if (result == true) {
                  folders.add(const GetAllFolders());
                  router.pop();
                }
              },
            )
          else
            MModalListTile(
              leading: const Icon(MIcons.plus),
              title: 'Add to Folder',
              onTap: () async {
                final result = await router.push(
                  Routes.addNoteToFolderModal,
                  extra: note,
                );
                if (result != null) {
                  folders.add(const GetAllFolders());
                  router.pop();
                }
              },
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
            onTap: () async {
              final r = await router.push(Routes.deleteNoteDialog, extra: note);
              if (r == true) router.pop();
            },
          ),
          Spaces.verticalSmall,
        ],
      ),
    );
  }
}
