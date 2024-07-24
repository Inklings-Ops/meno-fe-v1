import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MTag extends StatelessWidget {
  const MTag({
    super.key,
    required this.title,
    this.style,
    this.height = 20.0,
  });

  final String title;
  final TextStyle? style;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context)!;
    return Container(
      height: height.toScale,
      constraints: BoxConstraints(minHeight: height, maxHeight: height).radius,
      padding: EdgeInsets.symmetric(horizontal: $styles.insets.small),
      alignment: Alignment.centerLeft,
      decoration: ShapeDecoration(
        color: colors.inActiveContainer,
        shape: RoundedRectangleBorder(borderRadius: $styles.radius.micro),
      ),
      child: SizedBox(
        child: Center(
          child: MText(
            title,
            style: style ?? $styles.text.captionMedium,
            color: colors.onInActiveContainer,
          ),
        ),
      ),
    );
  }
}
