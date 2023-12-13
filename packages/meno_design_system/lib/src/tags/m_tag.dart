import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MTag extends StatelessWidget {
  const MTag({
    super.key,
    required this.title,
    this.style = MTextStyle.captionMedium,
    this.height,
  });

  final String title;
  final MTextStyle? style;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = MColorScheme.of(context)!;

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: MCore.small),
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: colorScheme.inActiveContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MCore.micro),
        ),
      ),
      child: MText(
        title,
        style: style,
        color: colorScheme.onInActiveContainer,
      ),
    );
  }
}
