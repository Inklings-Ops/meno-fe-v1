import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastCreatorWidget extends StatelessWidget {
  const BroadcastCreatorWidget({required this.creatorName, super.key});

  final String creatorName;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return MText(
      creatorName,
      color: colors.onDisabledContainer,
      style: textTheme.captionRegular,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }
}
