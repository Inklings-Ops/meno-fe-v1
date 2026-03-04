import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meno_design_system/meno_design_system.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog._({required this.title, required this.description})
    : super(key: null);

  final String title;
  final String description;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) =>
          ConfirmationDialog._(title: title, description: description),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
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
              foregroundColor: colors.onDisabled.withValues(alpha: 0.5),
              shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: MPrimaryButton(
            label: 'Log out',
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
