import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class DeleteNoteAlertDialog extends StatelessWidget {
  const DeleteNoteAlertDialog({
    super.key,
    required this.onDelete,
    this.onCancel,
  });
  final VoidCallback onDelete;
  final VoidCallback? onCancel;
  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;
    final bloc = context.watch<NotesBloc>();
    return AlertDialog(
      title: MText('Delete Note?', style: $styles.text.heading2Regular),
      contentPadding: const EdgeInsets.all(24).radius,
      content: MText(
        'Do want to delete this note?',
        style: $styles.text.captionRegular,
      ),
      actions: [
        SizedBox.fromSize(
          size: Size(85.toScale, 40.toScale),
          child: MTextButton(
            label: 'Cancel',
            onPressed: onCancel ?? () => context.pop(false),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onDisabled?.withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius: $styles.radius.small),
            ),
          ),
        ),
        SizedBox(
          height: 40.toScale,
          child: bloc.state.isLoading
              ? const MLoadingIndicator.four()
              : MDangerButton(
                  label: 'Delete',
                  onPressed: onDelete,
                  style: TextButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
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
