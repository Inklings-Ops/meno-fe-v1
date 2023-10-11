import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class CreateBroadcastListItem extends StatelessWidget {
  final String leadingText;
  final String subtitleText;
  final Widget? trailing;

  const CreateBroadcastListItem({
    super.key,
    required this.leadingText,
    required this.subtitleText,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: theme.disabledColor,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: SizedBox(
            height: 24,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MText(
                    leadingText,
                    style: MTextStyle.captionMedium,
                  ),
                ),
                MSize.horizontalSpaceLarge,
                trailing ?? const SizedBox(),
              ],
            ),
          ),
        ),
        MSize.verticalSpaceMicro,
        MText(subtitleText, style: MTextStyle.captionRegular),
      ],
    );
  }
}
