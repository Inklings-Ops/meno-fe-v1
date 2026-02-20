import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

class DeleteNoteAlertDialog extends StatelessWidget {
  const DeleteNoteAlertDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => const DeleteNoteAlertDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

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
            onPressed: () => context.pop(true),
            style: FilledButton.styleFrom(
              shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
            ),
          ),
        ),
      ],
    );
  }
}
