import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class DeleteNoteAlertDialog extends StatelessWidget {
  const DeleteNoteAlertDialog({required this.note, super.key});
  final Note note;

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final watcher = context.watch<NotesWatcherBloc>();

    return BlocListener<NotesWatcherBloc, NotesWatcherState>(
      listener: (ctx, state) {
        switch (state) {
          case NotesWatcherNoteDeleted(:final note):
            ctx.read<NotesBloc>().add(NotesNoteRemoved(note));
            ctx.read<FoldersBloc>().add(const FoldersGetFoldersRequested());
            router.pop(true);
          case NotesWatcherLoadFailed(:final exception):
            ctx.showErrorSnackBar(exception.message);
            router.pop(false);
          default:
        }
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
                foregroundColor: colorScheme.onDisabled.withValues(alpha: 0.5),
                shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: MDangerButton(
              label: 'Delete',
              loading: watcher.state is NotesWatcherLoadInProgress,
              onPressed: () => watcher.add(
                NotesWatcherDeleteNoteRequested(note),
              ),
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
