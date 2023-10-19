import 'package:flutter/material.dart';
import 'package:meno_design_system/meno_design_system.dart';
import 'package:meno_design_system/src/m_internal.dart';

class MBadge extends StatelessWidget {
  final MColor? color;
  final String? value;
  final String? viewCount;
  final MTextStyle? textStyle;
  final MColor? valueColor;
  final BorderRadiusGeometry? borderRadius;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;
  final bool showLoader;

  const MBadge.cohost({Key? key})
      : this._(
          key: key,
          value: "Co-host",
          constraints: const BoxConstraints(minHeight: 20.0, maxWidth: 59.0),
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: MColor.grey30,
          valueColor: MColor.primary700,
          textStyle: MTextStyle.microMedium,
        );

  const MBadge.host({Key? key})
      : this._(
          key: key,
          value: "Host",
          constraints: const BoxConstraints(minHeight: 20.0, maxWidth: 59.0),
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: MColor.grey30,
          valueColor: MColor.primary700,
          textStyle: MTextStyle.microMedium,
        );

  const MBadge.large({Key? key, required String value})
      : this._(
          key: key,
          value: value,
          padding: const EdgeInsets.fromLTRB(4.5, 2, 4.5, 2),
          constraints: const BoxConstraints(minHeight: 16.0, minWidth: 17.0),
        );

  const MBadge.live({Key? key, String? count})
      : this._(
          key: key,
          value: "LIVE",
          viewCount: count,
          height: 20,
          showLoader: true,
          constraints: const BoxConstraints(minHeight: 20.0),
          padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
        );

  MBadge.newBadge(BuildContext context, {Key? key})
      : this._(
          key: key,
          value: "NEW",
          constraints: const BoxConstraints(minHeight: 16.0),
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: MInternal.resolve(
            Theme.of(context).brightness == Brightness.light,
            MColor.newBadgeLight,
            MColor.newBadgeDark,
          ),
          valueColor: MColorScheme.of(context)?.primary,
        );

  const MBadge.small({Key? key})
      : this._(
          key: key,
          height: 6.0,
          width: 6.0,
          constraints: const BoxConstraints(minHeight: 6.0, minWidth: 6.0),
        );

  const MBadge._({
    Key? key,
    this.color,
    this.value,
    this.viewCount,
    this.textStyle = MTextStyle.nanoBold,
    this.valueColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(556)),
    this.height,
    this.width,
    this.padding,
    this.constraints,
    this.showLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    final MColorScheme colorScheme = MColorScheme.of(context)!;

    Widget? child;

    if (value != null) {
      child = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLoader)
            Assets.images.loading.image(
              color: valueColor ?? colorScheme.onError,
            ),
          _buildText(value!, colorScheme),
          if (viewCount != null) ...[
            const SizedBox(width: 6),
            _buildText(viewCount!, colorScheme),
          ],
        ],
      );
    }

    return Container(
      height: height,
      width: width,
      padding: padding,
      constraints: constraints,
      decoration: BoxDecoration(
        color: color ?? colorScheme.error,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }

  MText _buildText(String content, MColorScheme colorScheme) {
    return MText(
      content,
      textAlign: TextAlign.center,
      style: textStyle,
      color: valueColor ?? colorScheme.onError,
    );
  }
}
