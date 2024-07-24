import 'package:meno_fe_v1/meno.dart';

class BroadcastExitAlertDialog extends StatelessWidget {
  final bool isBroadcasting;
  const BroadcastExitAlertDialog({super.key, this.isBroadcasting = true});

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final borderRadius = $styles.radius.small;

    String label = isBroadcasting ? 'Stop Broadcasting?' : 'Leave Broadcast?';
    String content = isBroadcasting
        ? 'Do you want to end this live broadcast?'
        : 'Do you want to leave this live broadcast?';

    return AlertDialog(
      title: MText(label, style: $styles.text.heading2Regular),
      contentPadding: const EdgeInsets.all(24).radius,
      content: MText(content, style: $styles.text.captionRegular),
      actions: [
        SizedBox.fromSize(
          size: Size(85.toScale, 40.toScale),
          child: MTextButton(
            label: 'Cancel',
            onPressed: () => context.pop(false),
            style: TextButton.styleFrom(
              foregroundColor: colors.onDisabled?.withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
            ),
          ),
        ),
        SizedBox(
          height: 40.toScale,
          child: MDangerButton(
            label: isBroadcasting ? 'Stop' : 'Leave',
            onPressed: () => context.pop(true),
            style: TextButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.onError,
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
            ),
          ),
        ),
      ],
    );
  }
}
