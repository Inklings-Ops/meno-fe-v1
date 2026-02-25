import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

class RemoveAlertDialog extends StatelessWidget {
  const RemoveAlertDialog({
    required this.title,
    required this.description,
    required this.buttonText,
    super.key,
  });

  final String title;
  final String description;
  final String buttonText;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String description,
    String buttonText = 'Remove',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => RemoveAlertDialog(
        title: title,
        description: description,
        buttonText: buttonText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return AlertDialog(
      title: MText(title, style: textTheme.heading2Regular),
      contentPadding: const EdgeInsets.all(24),
      content: MText(description, style: textTheme.captionRegular),
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
          child: MPrimaryButton(
            label: buttonText,
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
