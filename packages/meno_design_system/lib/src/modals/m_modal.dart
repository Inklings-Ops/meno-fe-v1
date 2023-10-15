import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MModal extends StatelessWidget {
  final String title;
  final Widget content;
  final double? height;
  final BoxConstraints? constraints;
  final bool showCloseButton;

  const MModal({
    super.key,
    required this.title,
    required this.content,
    this.height,
    this.constraints,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      constraints: constraints,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(
        vertical: MCore.medium,
        horizontal: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MDragHandle(),
          MSize.verticalSpaceLarge,
          Row(
            children: [
              MText(title, style: MTextStyle.subheadingMedium),
              const Spacer(),
              if (showCloseButton)
                MIconButton(
                  icon: MIcons.x_close,
                  color: MColorScheme.of(context)?.onBackground,
                  onPressed: () => Navigator.pop(context),
                ),
            ],
          ),
          MSize.verticalSpaceSmall,
          const MDivider(),
          24.verticalSpace,
          content,
        ],
      ),
    );
  }
}

class MDragHandle extends StatelessWidget {
  const MDragHandle({
    super.key,
    this.dragHandleSize,
  });

  final Size? dragHandleSize;

  @override
  Widget build(BuildContext context) {
    final BottomSheetThemeData bottomSheetTheme =
        Theme.of(context).bottomSheetTheme;
    final Size handleSize =
        dragHandleSize ?? bottomSheetTheme.dragHandleSize ?? const Size(32, 4);

    return Semantics(
      label: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      container: true,
      child: Center(
        child: Container(
          height: handleSize.height,
          width: handleSize.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(handleSize.height / 2),
            color: bottomSheetTheme.dragHandleColor,
          ),
        ),
      ),
    );
  }
}
