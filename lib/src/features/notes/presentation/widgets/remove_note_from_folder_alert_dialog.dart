import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class DeleteNoteFromFolderAlertDialog extends StatelessWidget {
  const DeleteNoteFromFolderAlertDialog({
    super.key,
    required this.onDelete,
    this.onCancel,
  });

  final VoidCallback onDelete;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final bloc = context.watch<NotesBloc>();

    return AlertDialog(
      title: MText('Remove Note?', style: $styles.text.heading2Regular),
      contentPadding: const EdgeInsets.all(24).radius,
      content: MText(
        'Do you want to remove this note from this folder?',
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
          child: bloc.state.isLoading
              ? const MLoadingIndicator.four()
              : MDangerButton(
                  label: 'Remove',
                  onPressed: onDelete,
                  style: TextButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: $styles.radius.small,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
