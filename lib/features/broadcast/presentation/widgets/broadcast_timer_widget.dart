import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class BroadcastTimerWidget extends StatelessWidget {
  BroadcastTimerWidget({
    required this.formattedTime,
    this.isRunning = false,
    this.timeAgo = '',
    super.key,
    this.showTimeAgo = true,
    this.textStyle,
    this.color,
  }) : assert(
         (isRunning && showTimeAgo) && timeAgo.isNotEmpty,
         'Time ago must be provided when running',
       );

  final String formattedTime;
  final bool isRunning;
  final String timeAgo;
  final bool showTimeAgo;
  final TextStyle? textStyle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = MColorScheme.of(context);
    final textTheme = MTextTheme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Formatted time (HH:MM:SS)
        MText(
          formattedTime,
          style: textStyle ?? textTheme.captionRegular,
          color: color ?? colors.onDisabledContainer,
        ),

        // Time ago display (optional)
        if (isRunning && showTimeAgo) ...[
          Spaces.horizontalSmall,
          const MDot(),
          Spaces.horizontalSmall,
          MText(
            timeAgo,
            style: textTheme.captionRegular,
            color: color ?? colors.onDisabledContainer,
          ),
        ],
      ],
    );
  }
}
