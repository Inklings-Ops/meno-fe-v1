import 'package:meno_fe_v1/meno.dart';

class PermissionsSettingsRedirectionDialog extends StatelessWidget {
  const PermissionsSettingsRedirectionDialog({
    required this.message,
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context)!;

    return AlertDialog(
      title: MText('Permission Required', style: textTheme.heading2Regular),
      contentPadding: const EdgeInsets.all(24),
      content: MText(message, style: textTheme.captionRegular),
      actions: [
        SizedBox.fromSize(
          size: const Size(85, 40),
          child: MTextButton(
            label: 'Cancel',
            onPressed: () => context.pop(false),
            style: TextButton.styleFrom(
              foregroundColor: colors.onDisabled?.withValues(alpha: 0.5),
              shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: MDangerButton(
            label: 'Open Settings',
            onPressed: () => context.pop(true),
            style: TextButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.onError,
              shape: const RoundedRectangleBorder(borderRadius: Corners.sm),
            ),
          ),
        ),
      ],
    );
  }
}
