import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class DeleteFolderAlertDialog extends StatelessWidget {
  const DeleteFolderAlertDialog({
    required this.onDelete,
    required this.folder,
    super.key,
    this.onCancel,
  });

  final VoidCallback onDelete;
  final VoidCallback? onCancel;
  final Folder folder;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    final bloc = context.watch<FoldersBloc>();

    return BlocListener<FoldersBloc, FoldersState>(
      listenWhen: (c, p) => p != c,
      listener: (context, state) => state.whenOrNull(
        loaded: (folders) => context.go(Routes.notes),
      ),
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
              onPressed: onCancel ?? () => context.pop(false),
              style: TextButton.styleFrom(
                foregroundColor: colors.onDisabled?.withOpacity(0.5),
                shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            width: 88,
            child: bloc.state == const FoldersState.loading()
                ? const MLoadingIndicator.four()
                : MDangerButton(
                    label: 'Delete',
                    onPressed: () {
                      context.read<FoldersBloc>().add(DeleteFolder(folder));
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.error,
                      foregroundColor: colors.onError,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
