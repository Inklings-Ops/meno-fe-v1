import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:meno_design_system/meno_design_system.dart';

/// A widget that allows users to expand and collapse long text.
///
/// This widget displays a portion of the provided text with an option to
/// reveal the full content.
class MReadMoreText extends HookWidget {
  /// Creates a new `MReadMoreText` widget.
  ///
  /// * `text`: The full text content to be displayed.
  /// * `style`: An optional style to apply to the text.
  /// * `maxLines`: The initial number of lines to display before truncation
  /// (default: 3).
  const MReadMoreText(
    this.text, {
    super.key,
    this.style,
    this.maxLines = 3,
  });

  /// The full text content to be displayed.
  final String text;

  /// An optional style to apply to the text.
  final TextStyle? style;

  /// The initial number of lines to display before truncation.
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    final textTheme = MTextTheme.of(context)!;
    final effectiveMaxLines = useState(maxLines);
    final isReadMore = useState(false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MText(
          text,
          style: style ?? textTheme.captionRegular,
          maxLines: isReadMore.value ? null : effectiveMaxLines.value,
          overflow: isReadMore.value ? null : TextOverflow.ellipsis,
        ),
        Spaces.verticalMicro,
        GestureDetector(
          onTap: () => isReadMore.value = !isReadMore.value,
          child: MText(
            isReadMore.value ? 'less' : 'more',
            style: textTheme.captionMedium,
            color: colors.onBackgroundVariant,
          ),
        ),
      ],
    );
  }
}
