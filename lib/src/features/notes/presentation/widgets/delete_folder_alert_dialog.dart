import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class DeleteFolderAlertDialog extends StatelessWidget {
  const DeleteFolderAlertDialog({required this.folder, super.key});
  final Folder folder;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    final watcher = context.watch<NotesWatcherBloc>();

    return BlocListener<NotesWatcherBloc, NotesWatcherState>(
      listenWhen: (c, p) => p != c,
      listener: (ctx, state) {
        switch (state) {
          case NotesWatcherFolderDeleted(:final folder):
            ctx.read<FoldersBloc>().add(FoldersRemoveFolderRequested(folder));
            ctx.read<NotesBloc>().add(const NotesFetchNotesRequested());
            router.pop(true);
          case NotesWatcherLoadFailed(:final exception):
            ctx.showErrorSnackBar(exception.message);
            router.pop(false);
          default:
        }
      },
      child: AlertDialog(
        title: MText('Delete Folder?', style: textTheme.heading2Regular),
        contentPadding: const EdgeInsets.all(24),
        content: MText(
          'Do want to delete this folder?',
          style: textTheme.captionRegular,
        ),
        actions: [
          SizedBox.fromSize(
            size: const Size(85, 40),
            child: MTextButton(
              label: 'Cancel',
              onPressed: () => context.pop(false),
              style: TextButton.styleFrom(
                foregroundColor: colors.onDisabled.withValues(alpha: 0.5),
                shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
              ),
            ),
          ),
          MDangerButton(
            label: 'Delete',
            loading: watcher.state is NotesWatcherLoadInProgress,
            onPressed: () => watcher.add(
              NotesWatcherDeleteFolderRequested(folder),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.onError,
            ),
          ),
        ],
      ),
    );
  }
}
