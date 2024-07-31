import 'package:meno_fe_v1/meno.dart';

class BroadcastExitAlertDialog extends StatelessWidget {
  final bool isBroadcasting;
  const BroadcastExitAlertDialog({super.key, this.isBroadcasting = true});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    const borderRadius = Corners.small;

    String label = isBroadcasting ? 'Stop Broadcasting?' : 'Leave Broadcast?';
    String content = isBroadcasting
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
            onPressed: () => context.pop(false),
            style: TextButton.styleFrom(
              foregroundColor: colors.onDisabled?.withOpacity(0.5),
              shape: const RoundedRectangleBorder(borderRadius: borderRadius),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: MDangerButton(
            label: isBroadcasting ? 'Stop' : 'Leave',
            onPressed: () => context.pop(true),
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
