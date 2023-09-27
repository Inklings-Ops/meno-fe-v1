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
          constraints: const BoxConstraints(minHeight: 20.0),
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
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
  });

  @override
  Widget build(BuildContext context) {
    final MColorScheme colorScheme = MColorScheme.of(context)!;

    return Container(
      height: height,
      width: width,
      padding: padding,
      constraints: constraints,
      decoration: BoxDecoration(
        color: color ?? colorScheme.error,
        borderRadius: borderRadius,
      ),
      child: value == null
          ? null
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildText(value!, colorScheme),
                if (viewCount != null) ...[
                  const SizedBox(width: 6),
                  _buildText(viewCount!, colorScheme),
                ],
              ],
            ),
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
