import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class DeleteNoteAlertDialog extends StatelessWidget {
  const DeleteNoteAlertDialog({required this.note, super.key});
  final Note note;

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;

    final watcher = context.watch<NotesWatcherBloc>();

    return BlocListener<NotesWatcherBloc, NotesWatcherState>(
      listener: (context, state) {
        state.whenOrNull(
          noteDeleted: (note) {
            context.read<NotesBloc>().add(NoteRemoved(note));
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
        title: MText('Delete Note?', style: textTheme.heading2Regular),
        contentPadding: const EdgeInsets.all(24),
        content: MText(
          'Do want to delete this note?',
          style: textTheme.captionRegular,
        ),
        actions: [
          SizedBox.fromSize(
            size: const Size(85, 40),
            child: MTextButton(
              label: 'Cancel',
              onPressed: () => context.pop(false),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.onDisabled?.withValues(alpha: 0.5),
                shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: MDangerButton(
              label: 'Delete',
              loading: watcher.state is NoteWatcherLoading,
              onPressed: () => watcher.add(DeleteNote(note)),
              style: FilledButton.styleFrom(
                shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
