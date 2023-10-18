import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

import 'broadcaster_info_modal.dart';

class BroadcastControls extends StatelessWidget {
  const BroadcastControls({super.key});

  @override
  Widget build(BuildContext context) {
    final MColorScheme colorScheme = MColorScheme.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MIconButton(
          icon: MIcons.microphone,
          color: colorScheme.primary,
          isFilled: true,
          fillColor: colorScheme.primary?.withOpacity(0.1),
        ),
        30.horizontalSpace,
        MIconButton(
          icon: MIcons.stop,
          color: colorScheme.error,
          isFilled: true,
          fillColor: colorScheme.error?.withOpacity(0.1),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const MText(
                "End Broadcast",
                style: MTextStyle.heading2Regular,
              ),
              contentPadding: const EdgeInsets.all(24),
              content: const MText(
                "Do you want to end this live broadcast?",
                style: MTextStyle.captionRegular,
              ),
              actions: [
                MTextButton(label: "Cancel", onPressed: () {}),
                MPrimaryButton(label: "End Broadcast", onPressed: () {}),
              ],
            ),
          ),
        ),
        30.horizontalSpace,
        MIconButton(
          icon: MIcons.dots_horizontal,
          color: colorScheme.onBackground,
          isFilled: true,
          fillColor: colorScheme.onBackground?.withOpacity(0.1),
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const BroadcasterInfoModal(),
          ),
        ),
      ],
    );
  }
}
