import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MModalTitleBar extends StatelessWidget {
  const MModalTitleBar({
    super.key,
    required this.title,
    this.showCloseButton = true,
    this.padding,
  });

  final String title;
  final bool showCloseButton;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 24.toScale,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MText(title, style: $styles.text.subheadingMedium),
                if (showCloseButton)
                  MIconButton(
                    icon: const Icon(MIcons.x_close),
                    color: MColorScheme.of(context)?.onBackground,
                    onPressed: () => Navigator.pop(context),
                  ),
              ],
            ),
          ),
          $styles.spaces.verticalSmall,
          const MDivider(),
        ],
      ),
    );
  }
}
