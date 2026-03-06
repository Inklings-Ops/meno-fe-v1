import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastExitAlertDialog extends StatelessWidget {
  const BroadcastExitAlertDialog._(this.isHost) : super(key: null);

  final bool isHost;

  static Future<bool?> show(BuildContext context, bool isHost) {
    return showDialog<bool>(
      context: context,
      builder: (_) => BroadcastExitAlertDialog._(isHost),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);
    const borderRadius = Corners.sm;

    final label = isHost ? 'Stop Broadcasting?' : 'Leave Broadcast?';
    final content = isHost
        ? 'Do you want to end this live broadcast?'
        : 'Do you want to leave this live broadcast?';

    return AlertDialog(
      title: MText(label, style: textTheme.heading2Regular),
      contentPadding: const EdgeInsets.all(24),
      content: MText(content, style: textTheme.captionRegular),
      actions: [
        SizedBox.fromSize(
          size: const Size(85, 40),
          child: MTextButton(
            label: 'Cancel',
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              foregroundColor: colors.onDisabled.withValues(alpha: 0.5),
              shape: const RoundedRectangleBorder(borderRadius: borderRadius),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: MDangerButton(
            label: isHost ? 'Stop' : 'Leave',
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.onError,
              shape: const RoundedRectangleBorder(borderRadius: borderRadius),
            ),
          ),
        ),
      ],
    );
  }
}
