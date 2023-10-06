import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';

class MModal extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final double? height;

  const MModal({
    super.key,
    required this.title,
    required this.children,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(
        vertical: MCore.medium,
        horizontal: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MDragHandle(),
            MSize.verticalSpaceLarge,
            MText(title, style: MTextStyle.subheadingMedium),
            MSize.verticalSpaceSmall,
            const MDivider(),
            24.verticalSpace,
            ...children,
          ],
        ),
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
