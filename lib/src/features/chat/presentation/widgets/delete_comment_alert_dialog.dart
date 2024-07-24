import 'package:meno_fe_v1/meno.dart';

class DeleteCommentAlertDialog extends StatelessWidget {
  const DeleteCommentAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return AlertDialog(
      title: MText('Delete Comment?', style: $styles.text.heading2Regular),
      contentPadding: const EdgeInsets.all(24).radius,
      content: MText(
        'Delete your comment permanently?',
        style: $styles.text.captionRegular,
      ),
      actions: [
        SizedBox.fromSize(
          size: Size(85.toScale, 40.toScale),
          child: MTextButton(
            label: 'Cancel',
            onPressed: () => context.pop(false),
            style: TextButton.styleFrom(
              foregroundColor: colors.onDisabled?.withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius: $styles.radius.small),
            ),
          ),
        ),
        SizedBox(
          height: 40.toScale,
          child: MDangerButton(
            label: 'Delete',
            onPressed: () => context.pop(true),
            style: TextButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.onError,
              shape: RoundedRectangleBorder(borderRadius: $styles.radius.small),
            ),
          ),
        ),
      ],
    );
  }
}
