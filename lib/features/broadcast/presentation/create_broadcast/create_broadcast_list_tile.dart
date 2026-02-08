import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class CreateBroadcastListTile extends StatelessWidget {
  const CreateBroadcastListTile({
    required this.leadingText,
    required this.subtitleText,
    super.key,
    this.trailing,
  });

  final String leadingText;
  final String subtitleText;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: theme.disabled,
            borderRadius: Corners.sm,
          ),
          child: SizedBox(
            height: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MText(leadingText, style: textTheme.captionMedium),
                ),
                Spaces.horizontalLarge,
                trailing ?? const SizedBox(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 18,
          child: MText(subtitleText, style: textTheme.captionRegular),
        ),
      ],
    );
  }
}
