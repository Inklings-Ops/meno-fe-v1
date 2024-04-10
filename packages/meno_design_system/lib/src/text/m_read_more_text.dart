import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MReadMoreText extends HookWidget {
  const MReadMoreText(
    this.text, {
    super.key,
    this.style,
    this.maxLines = 3,
  });

  final String text;
  final TextStyle? style;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;
    final effectiveMaxLines = useState(maxLines);
    final isReadMore = useState(false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MText(
          text,
          style: style ?? MTextStyle.captionRegular,
          maxLines: isReadMore.value ? null : effectiveMaxLines.value,
          overflow: isReadMore.value ? null : TextOverflow.ellipsis,
        ),
        const SizedBox(height: MCore.micro),
        GestureDetector(
          onTap: () => isReadMore.value = !isReadMore.value,
          child: MText(
            isReadMore.value ? "less" : "more",
            style: MTextStyle.captionMedium,
            color: colorScheme.onBackgroundVariant,
          ),
        ),
      ],
    );
  }
}
