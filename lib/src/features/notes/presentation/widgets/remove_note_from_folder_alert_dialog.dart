import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class RemoveNoteFromFolderAlertDialog extends StatelessWidget {
  const RemoveNoteFromFolderAlertDialog({required this.note, super.key});
  final Note note;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;

    final watcher = context.watch<NotesWatcherBloc>();

    return BlocListener<NotesWatcherBloc, NotesWatcherState>(
      listener: (context, state) {
        state.whenOrNull(
          noteRemovedFromFolder: (note, folder) {
            context.read<NotesBloc>().add(NoteReceived(note));
            context.read<FoldersBloc>().add(const GetAllFolders());
            router.pop(true);
          },
          failure: (exception) {
            context.showNoteError(exception);
            router.pop(false);
          },
        );
      },
      child: AlertDialog(
        title: MText('Remove Note?', style: textTheme.heading2Regular),
        contentPadding: const EdgeInsets.all(24),
        content: MText(
          'Do you want to remove this note from this folder?',
          style: textTheme.captionRegular,
        ),
        actions: [
          SizedBox.fromSize(
            size: const Size(85, 40),
            child: MTextButton(
              label: 'Cancel',
              onPressed: router.pop,
              style: TextButton.styleFrom(
                foregroundColor: colors.onDisabled?.withOpacity(0.5),
                shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: MPrimaryButton(
              label: 'Remove',
              onPressed: () => watcher.add(
                RemoveNoteFromFolder(note, note.folder!),
              ),
              loading: watcher.state is NoteWatcherLoading,
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
