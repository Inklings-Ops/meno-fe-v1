import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class DeleteFolderAlertDialog extends StatelessWidget {
  const DeleteFolderAlertDialog({
    super.key,
    required this.onDelete,
    this.onCancel,
  });

  final VoidCallback onDelete;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final bloc = context.watch<FolderListBloc>();

    return AlertDialog(
      title: MText('Delete Folder?', style: $styles.text.heading2Regular),
      contentPadding: const EdgeInsets.all(24).radius,
      content: MText(
        'Do want to delete this folder?',
        style: $styles.text.captionRegular,
      ),
      actions: [
        SizedBox.fromSize(
          size: Size(85.toScale, 40.toScale),
          child: MTextButton(
            label: 'Cancel',
            onPressed: onCancel ?? () => context.pop(false),
            style: TextButton.styleFrom(
              foregroundColor: colors.onDisabled?.withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius: $styles.radius.small),
            ),
          ),
        ),
        SizedBox(
          height: 40.toScale,
          width: 88.toScale,
          child: bloc.state == const FolderListState.loading()
              ? const MLoadingIndicator.four()
              : MDangerButton(
                  label: 'Delete',
                  onPressed: onDelete,
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.error,
                    foregroundColor: colors.onError,
                  ),
                ),
        ),
      ],
    );
  }
}
