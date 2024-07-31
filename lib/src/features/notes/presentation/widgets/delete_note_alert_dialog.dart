import 'package:meno_fe_v1/meno.dart';
import 'package:meno_fe_v1/src/features/notes/notes.dart';

class DeleteNoteAlertDialog extends StatelessWidget {
  const DeleteNoteAlertDialog({
    required this.onDelete, super.key,
    this.onCancel,
  });
  final VoidCallback onDelete;
  final VoidCallback? onCancel;
  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    final bloc = context.watch<NotesBloc>();
    return AlertDialog(
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
            onPressed: onCancel ?? () => context.pop(false),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onDisabled?.withOpacity(0.5),
              shape: const RoundedRectangleBorder(borderRadius: Corners.small),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: bloc.state.isLoading
              ? const MLoadingIndicator.four()
              : MDangerButton(
                  label: 'Delete',
                  onPressed: onDelete,
                  style: TextButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                    shape: const RoundedRectangleBorder(
                      borderRadius: Corners.small,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
